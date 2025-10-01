//
//  ExpenseSectionView.swift
//  CashflowTracker
//
//  Created by Maria Rachel on 9/16/25.
//

import SwiftUI

struct ExpenseSectionView: View {
    @Binding var period: CashflowPeriod
    var onAdd: () -> Void
    
    // Track which expense to edit
    @State private var expenseToEdit: Expense? = nil
    
    var body: some View {
        Section(header: Text("Expenses")) {
            headerView
            
            ForEach($period.expenses) { $expense in
                ExpenseRow(expense: $expense)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        // Delete button
                        Button(role: .destructive) {
                            if let index = period.expenses.firstIndex(where: { $0.id == expense.id }) {
                                period.expenses.remove(at: index)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        
                        // Edit button
                        Button {
                            expenseToEdit = expense
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                        
                        
                    }
            }
            
            totalView
        }
        .sheet(item: $expenseToEdit) { editingExpense in
            if let binding = bindingForExpense(editingExpense) {
                EditExpenseView(expense: binding)
            }
        }
    }
    
    private func bindingForExpense(_ expense: Expense) -> Binding<Expense>? {
        guard let index = period.expenses.firstIndex(where: { $0.id == expense.id }) else {
            return nil
        }
        return $period.expenses[index]
    }
    
    private var headerView: some View {
        HStack {
            Text("Expenses")
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
        Text("Total Expenses: \(period.totalExpenses, format: .currency(code: "PHP"))")
            .bold()
            .padding(.top, 4)
    }
}

// MARK: - Row
struct ExpenseRow: View {
    @Binding var expense: Expense
    
    var body: some View {
        HStack {
            Button {
                expense.isSpent.toggle()
            } label: {
                Image(systemName: expense.isSpent ? "checkmark.square.fill" : "square")
            }
            .buttonStyle(.borderless)
            
            Text(expense.item)
                .foregroundColor(expense.isSpent ? .gray : .primary)
            
            Spacer()
            
            Text(expense.amount, format: .currency(code: "PHP"))
                .foregroundColor(expense.isSpent ? .gray : .primary)
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Simple Editor for Expense
struct EditExpenseView: View {
    @Binding var expense: Expense
    @Environment(\.dismiss) private var dismiss
    
    @State private var item: String = ""
    @State private var amount: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Account") {
                    Text(expense.account) // fixed account
                }
                
                Section("Item") {
                    TextField("Item", text: $item)
                }
                
                Section("Amount") {
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Edit Expense")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let newAmount = Double(amount) {
                            expense.amount = newAmount
                        }
                        expense.item = item
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            item = expense.item
            amount = String(expense.amount)
        }
    }
}
