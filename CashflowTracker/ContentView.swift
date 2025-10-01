//
//  ContentView.swift
//  CashflowTracker
//
//  Created by Maria Rachel on 9/14/25.
//

import SwiftUI

struct ContentView: View {
    private let store = DataStore()

    // single-month state (the "one month" model you decided on)
    @State private var currentMonth: MonthlyCashflow
    @State private var allSources: [IncomeSource]
    @State private var allAccounts: [Account]

    @State private var showAddIncomeSource = false
    @State private var showAddAccount = false
    @State private var showClearMonthAlert = false

    // load saved data (or create a fresh month)
    init() {
        // load persisted month (if any)
        if let data = UserDefaults.standard.data(forKey: "cashflow_currentMonth"),
           let decoded = try? JSONDecoder().decode(MonthlyCashflow.self, from: data) {

            // Check if it's still the same month
            if decoded.monthName == Date().monthNameAndYear() {
                _currentMonth = State(initialValue: decoded)
            } else {
                // New month -> reset
                _currentMonth = State(initialValue:
                    MonthlyCashflow(
                        monthName: Date().monthNameAndYear(),
                        firstHalf: CashflowPeriod(name: "First Half", incomes: [], expenses: []),
                        secondHalf: CashflowPeriod(name: "Second Half", incomes: [], expenses: [])
                    )
                )
            }

        } else {
            // no saved month -> create fresh
            _currentMonth = State(initialValue:
                MonthlyCashflow(
                    monthName: Date().monthNameAndYear(),
                    firstHalf: CashflowPeriod(name: "First Half", incomes: [], expenses: []),
                    secondHalf: CashflowPeriod(name: "Second Half", incomes: [], expenses: [])
                )
            )
        }

        // load sources/accounts lists
        _allSources = State(initialValue: store.load([IncomeSource].self, forKey: "income_sources") ?? [])
        _allAccounts = State(initialValue: store.load([Account].self, forKey: "accounts") ?? [])
    }

    var body: some View {
        NavigationStack {
            List {
                monthSection     // 🔹 Month first
                summarySection   // 🔹 Summary below
                manageSection
            }
            .navigationTitle("Monthly Cashflow")
            // show an alert to confirm clearing the month
            .alert("Clear Current Month?", isPresented: $showClearMonthAlert) {
                Button("Clear", role: .destructive) {
                    resetMonth()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This will remove all data for the current month. Are you sure?")
            }
            // save when the view disappears (safe fallback)
            .onDisappear {
                saveCurrentMonth(currentMonth)
            }
        }
    }


    // MARK: - Month view (first + second half)
    private var monthSection: some View {
        Section(header: Text(currentMonth.monthName).font(.title3).bold()) {
            PeriodSection(
                period: $currentMonth.firstHalf,
                allSources: allSources,
                allAccounts: allAccounts
            )

            PeriodSection(
                period: $currentMonth.secondHalf,
                allSources: allSources,
                allAccounts: allAccounts
            )
        }
    }
    
    // MARK: - Totals / Summary
    private var totalIncome: Double {
        currentMonth.firstHalf.totalIncome + currentMonth.secondHalf.totalIncome
    }

    private var totalExpenses: Double {
        currentMonth.firstHalf.totalExpenses + currentMonth.secondHalf.totalExpenses
    }

    private var summarySection: some View {
        Section(header: Text("Summary").font(.headline)) {
            HStack {
                Text("Total Income").foregroundStyle(.secondary)
                Spacer()
                Text(totalIncome, format: .currency(code: "PHP"))
                    .foregroundStyle(.secondary)
            }
            HStack {
                Text("Total Expenses").foregroundStyle(.secondary)
                Spacer()
                Text(totalExpenses, format: .currency(code: "PHP"))
                    .foregroundStyle(.secondary)
            }
            HStack {
                Text("Balance").foregroundStyle(.secondary)
                Spacer()
                Text((totalIncome - totalExpenses), format: .currency(code: "PHP"))
                    .foregroundColor(totalIncome >= totalExpenses ? .secondary : .red)
            }
        }
    }

    // MARK: - Manage / Add buttons
    private var manageSection: some View {
        Section {
            NavigationLink("Manage Income Sources") {
                        ManageIncomeSourcesView(sources: $allSources)
                    }

            NavigationLink("Manage Accounts") {
                        ManageAccountsView(accounts: $allAccounts)
                    }
            
            Button("➕ Add Income Source") {
                showAddIncomeSource = true
            }
            .sheet(isPresented: $showAddIncomeSource) {
                AddIncomeSourceView { newSource in
                    allSources.append(newSource)
                    store.save(allSources, forKey: "income_sources")
                }
            }

            Button("➕ Add Account") {
                showAddAccount = true
            }
            .sheet(isPresented: $showAddAccount) {
                AddAccountView { newAccount in
                    allAccounts.append(newAccount)
                    store.save(allAccounts, forKey: "accounts")
                }
            }

            Button("🗑️ Clear Month") {
                showClearMonthAlert = true
            }
            .foregroundColor(.red)
        }
    }

    // MARK: - Persistence helpers
    private func saveCurrentMonth(_ month: MonthlyCashflow) {
        guard let encoded = try? JSONEncoder().encode(month) else { return }
        UserDefaults.standard.set(encoded, forKey: "cashflow_currentMonth")
    }

    private func resetMonth() {
        currentMonth = MonthlyCashflow(
            monthName: Date().monthNameAndYear(),
            firstHalf: CashflowPeriod(name: "First Half", incomes: [], expenses: []),
            secondHalf: CashflowPeriod(name: "Second Half", incomes: [], expenses: [])
        )
        saveCurrentMonth(currentMonth)
    }
}
// MARK: - Preview
#Preview {
    ContentView()
}
