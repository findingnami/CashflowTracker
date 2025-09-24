//
//  ContentView.swift
//  CashflowTracker
//
//  Created by Maria Rachel on 9/14/25.
//

import SwiftUI


struct ContentView: View {
    @State private var months: [MonthlyCashflow]
    @State private var allSources: [IncomeSource]
    @State private var allAccounts: [Account]
    @State private var showAddIncomeSource = false
    @State private var showAddAccount = false

    init(
        months: [MonthlyCashflow] = [],
        allSources: [IncomeSource] = [],
        allAccounts: [Account] = []
    ) {
        _months = State(initialValue: months)
        _allSources = State(initialValue: allSources)
        _allAccounts = State(initialValue: allAccounts)
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach($months) { $month in
                        // Month title at the very top (no Section styling)
                       /* Text(month.monthName)
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.top, 12) */

                        // ── First Half ──
                        Section {
                            PeriodSection(
                                period: $month.firstHalf,
                                allSources: allSources,
                                allAccounts: allAccounts
                            )
                        }

                        // ── Second Half ──
                        Section {
                            PeriodSection(
                                period: $month.secondHalf,
                                allSources: allSources,
                                allAccounts: allAccounts
                            )
                        }
                    }


                Section {
                    Button("Add Income Source") { showAddIncomeSource = true }
                        .sheet(isPresented: $showAddIncomeSource) {
                            AddIncomeSourceView { allSources.append($0) }
                        }

                    Button("Add Account") { showAddAccount = true }
                        .sheet(isPresented: $showAddAccount) {
                            AddAccountView { allAccounts.append($0) }
                        }
                }
            }
            .navigationTitle("Monthly Cashflow")
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView(
        months: [
            MonthlyCashflow(
                monthName: "September 2025",
                firstHalf: CashflowPeriod(name: "First Half", incomes: [], expenses: []),
                secondHalf: CashflowPeriod(name: "Second Half", incomes: [], expenses: [])
            )
        ],
        allSources: [IncomeSource(name: "Salary")],
        allAccounts: [Account(name: "BDO Savings")]
    )
}
