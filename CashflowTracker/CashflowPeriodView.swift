//
//  CashflowPeriodView.swift
//  CashflowTracker
//
//  Created by Maria Rachel on 9/14/25.
//

import SwiftUI

/// Identifies which sheet is currently active.
enum ActiveSheet: Identifiable, Codable {
    case income, expense
    var id: Int { hashValue }
}

struct CashflowPeriodView: View {
    // MARK: - Inputs from the parent
    @Binding var period: CashflowPeriod
    let allSources: [IncomeSource]    // for the AddIncomeView
    let allAccounts: [Account]        // for the AddExpenseView

    // MARK: - Local state
    @State private var activeSheet: ActiveSheet? = nil

    var body: some View {
        List {
            IncomeSectionView(period: $period) {
                activeSheet = .income
            }

            ExpenseSectionView(period: $period) {
                activeSheet = .expense
            }

            AllocationSectionView(allocations: period.allocations)
        }
        .navigationTitle("Cashflow: \(period.name)")
        .toolbar { EditButton() }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .income:
                // Provide both the period and the available income sources
                AddIncomeView(
                    period: $period,
                    sources: allSources
                )

            case .expense:
                // Provide the available accounts and a save handler
                AddExpenseView(
                    accounts: allAccounts,
                    onSave: { newExpense in
                        // Parent updates the period’s expenses
                        period.expenses.append(newExpense)
                    }
                )
            }
        }
    }
}

// MARK: - Preview
struct CashflowPeriodView_PreviewWrapper: View {
    @State private var period = CashflowPeriod(
        name: "Preview Period",
        incomes: [],
        expenses: []
    )

    private let demoSources = [
        IncomeSource(name: "Salary"),
        IncomeSource(name: "Freelance")
    ]

    private let demoAccounts = [
        Account(name: "Cash"),
        Account(name: "Bank")
    ]

    var body: some View {
        CashflowPeriodView(
            period: $period,
            allSources: demoSources,
            allAccounts: demoAccounts
        )
    }
}

#Preview {
    NavigationStack {
        CashflowPeriodView_PreviewWrapper()
    }
}
