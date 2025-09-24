//
//  AddExpenseView.swift
//  CashflowTracker
//

import SwiftUI

struct AddExpenseView: View {
    @Environment(\.dismiss) private var dismiss

    // Parent supplies accounts and a save callback
    let accounts: [Account]
    var onSave: (Expense) -> Void

    // use ID for selection (simple and fast for the compiler)
    @State private var selectedAccountID: UUID?
    @State private var item: String = ""
    @State private var amount: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Account")) {
                    Picker("Select Account", selection: $selectedAccountID) {
                        ForEach(accounts, id: \.id) { account in
                            Text(account.name)
                                .tag(account.id as UUID?) // tag an Optional<UUID>
                        }
                    }
                }

                Section(header: Text("Expense Details")) {
                    TextField("Item", text: $item)
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Add Expense")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard
                            let selectedID = selectedAccountID,
                            let account = accounts.first(where: { $0.id == selectedID }),
                            let amountValue = Double(amount)
                        else { return }

                        let newExpense = Expense(account: account.name,
                                                 item: item,
                                                 amount: amountValue)
                        onSave(newExpense)
                        dismiss()
                    }
                    .disabled(selectedAccountID == nil || item.isEmpty || Double(amount) == nil)
                }
            }
        }
    }
}

struct AddExpenseView_PreviewWrapper: View {
    @State private var saved: Expense?

    var sampleAccounts: [Account] = [
        Account(name: "Cash"),
        Account(name: "BPI")
    ]

    var body: some View {
        AddExpenseView(accounts: sampleAccounts) { expense in
            // preview stub: capture the saved expense or ignore
            saved = expense
            print("Saved expense: \(expense)")
        }
    }
}

#Preview {
    NavigationStack {
        AddExpenseView_PreviewWrapper()
    }
}
