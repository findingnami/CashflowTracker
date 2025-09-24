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

    var body: some View {
        // Explicitly reference SwiftUI.Section to avoid any name collisions
        SwiftUI.Section(header: Text("Income")) {
            headerView
            incomeRows
            totalView
        }
    }

    // MARK: - Subpieces kept tiny to help the compiler

    private var headerView: some View {
        HStack {
            Text("Income")
                .font(.title2)
                .bold()
            Spacer()
            Button(action: onAdd) {
                Image(systemName: "plus")
            }
            .buttonStyle(.borderless) // nice inside lists
        }
    }

    @ViewBuilder
    private var incomeRows: some View {
        ForEach($period.incomes) { $income in
            IncomeRow(income: $income)
        }
    }

    private var totalView: some View {
        Text("Total Income: \(period.totalIncome, format: .currency(code: "PHP"))")
            .bold()
            .padding(.top, 4)
    }
}

// Small row view — separated so the compiler has very tiny expressions to check
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

            // NOTE: depending on your IncomeSource model:
            // • if IncomeSource is now a @Model class with `var name: String` use `.name`
            // • if it's still an enum use `.rawValue`
            //
            // I'll show the class-name version below; change to `.rawValue` if you still have an enum.
            Text(income.source)
                .foregroundColor(income.isReceived ? .primary : .gray)

            Spacer()

            Text(income.amount, format: .currency(code: "PHP"))
                .foregroundColor(income.isReceived ? .primary : .gray)
        }
        .padding(.vertical, 6)
    }
}




