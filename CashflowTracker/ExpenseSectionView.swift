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
    
    var body: some View {
        Section("Expenses") {
            HStack {
                Text("Expenses")
                    .font(.title2)
                    .bold()
                Spacer()
                Button(action: onAdd) {
                    Image(systemName: "plus")
                }
            }
            
            ForEach($period.expenses) { $expense in
                HStack {
                    Button {
                        expense.isSpent.toggle()
                    } label: {
                        Image(systemName: expense.isSpent ? "checkmark.square.fill" : "square")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    
                    Text(expense.item)
                        .foregroundColor(expense.isSpent ? .gray : .primary)
                    Spacer()
                    Text("\(expense.amount, format: .currency(code: "PHP"))")
                        .foregroundColor(expense.isSpent ? .gray : .primary)
                }
            }
            
            Text("Total Expenses: \(period.totalExpenses, format: .currency(code: "PHP"))")
                .bold()
                .padding(.top, 4)
        }
    }
}
