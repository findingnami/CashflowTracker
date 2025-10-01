//
//  IncomeSectionView.swift
//  CashflowTracker
//
//  Created by Maria Rachel on 9/16/25.
//

import SwiftUI

// IncomeSectionView.swift

struct IncomeSectionView: View {
    @Binding var period: CashflowPeriod
    var onAdd: () -> Void

    // Track which income to edit
    @State private var incomeToEdit: Income? = nil

    var body: some View {
        SwiftUI.Section(header: Text("Income")) {
            headerView

            ForEach($period.incomes) { $income in
                IncomeRow(income: $income)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        // Delete button
                        Button(role: .destructive) {
                            if let index = period.incomes.firstIndex(where: { $0.id == income.id }) {
                                period.incomes.remove(at: index)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        
                        // Edit button
                        Button {
                            incomeToEdit = income
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)

                        
                    }
            }

            totalView
        }
        .sheet(item: $incomeToEdit) { editingIncome in
            if let binding = bindingForIncome(editingIncome) {
                EditIncomeView(income: binding)
            }
        }
    }

    private func bindingForIncome(_ income: Income) -> Binding<Income>? {
        guard let index = period.incomes.firstIndex(where: { $0.id == income.id }) else {
            return nil
        }
        return $period.incomes[index]
    }

    private var headerView: some View {
        HStack {
            Text("Income")
                .font(.title2)
                .bold()
            Spacer()
            Button(action: onAdd) {
                Image(systemName: "plus")
            }
            .buttonStyle(.borderless)
        }
    }

    private var totalView: some View {
        Text("Total Income: \(period.totalIncome, format: .currency(code: "PHP"))")
            .bold()
            .padding(.top, 4)
    }
}

// MARK: - Row
struct IncomeRow: View {
    @Binding var income: Income

    var body: some View {
        HStack {
            Button {
                income.isReceived.toggle()
            } label: {
                Image(systemName: income.isReceived ? "checkmark.square.fill" : "square")
            }
            .buttonStyle(.borderless)

            Text(income.source)
                .foregroundColor(income.isReceived ? .primary : .gray)

            Spacer()

            Text(income.amount, format: .currency(code: "PHP"))
                .foregroundColor(income.isReceived ? .primary : .gray)
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Simple Editor for Income
struct EditIncomeView: View {
    @Binding var income: Income
    @Environment(\.dismiss) private var dismiss

    @State private var amount: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Source") {
                    Text(income.source)
                }
                Section("Amount") {
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Edit Income")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let newAmount = Double(amount) {
                            income.amount = newAmount
                        }
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            amount = String(income.amount)
        }
    }
}
