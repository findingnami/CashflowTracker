//
//  AddIncomeView.swift
//  CashflowTracker
//
//  Created by Maria Rachel on 9/14/25.
//

import SwiftUI

struct AddIncomeView: View {
    @Environment(\.dismiss) private var dismiss

    // Accept a binding so we can mutate the parent
    @Binding var period: CashflowPeriod
    let sources: [IncomeSource]

    // Use a String selection to keep Picker simple & fast to type-check
    @State private var selectedSourceName: String? = nil
    @State private var amount: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Source") {
                    Picker("Select Source", selection: $selectedSourceName) {
                        // optional placeholder
                        Text("Choose...").tag(nil as String?)
                        ForEach(sources, id: \.name) { source in
                            Text(source.name).tag(source.name as String?)
                        }
                    }

                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Add Income")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard
                            let chosenName = selectedSourceName,
                            let chosenSource = sources.first(where: { $0.name == chosenName }),
                            let amountValue = Double(amount)
                        else { return }

                        // Income expects an IncomeSource model instance
                        let newIncome = Income(source: chosenSource.name, amount: amountValue)
                        period.incomes.append(newIncome)
                        dismiss()
                    }
                    .disabled(selectedSourceName == nil || Double(amount) == nil)
                }
            }
        }
    }
}

struct AddIncomeView_PreviewWrapper: View {
    @State private var period = CashflowPeriod(
        name: "Preview Period",
        incomes: [],
        expenses: []
    )

    private let demoSources = [
        IncomeSource(name: "Salary"),
        IncomeSource(name: "Freelance")
    ]

    var body: some View {
        AddIncomeView(period: $period, sources: demoSources)
    }
}

#Preview {
    NavigationStack {
        AddIncomeView_PreviewWrapper()
    }
}
