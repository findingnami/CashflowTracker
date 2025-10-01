//
//  ContentView.swift
//  CashflowTracker
//
//  Created by Maria Rachel on 9/14/25.
//

import SwiftUI

struct ContentView: View {
    private let store = DataStore()

    @State private var currentMonth: MonthlyCashflow
    @State private var nextMonth: MonthlyCashflow
    @State private var allSources: [IncomeSource]
    @State private var allAccounts: [Account]

    @State private var showAddIncomeSource = false
    @State private var showAddAccount = false

    init() {
        let thisMonthDate = Date()
        let thisMonthName = thisMonthDate.monthNameAndYear()

        let nextMonthDate = Calendar.current.date(byAdding: .month, value: 1, to: thisMonthDate)!
        let nextMonthName = nextMonthDate.monthNameAndYear()

        if let data = UserDefaults.standard.data(forKey: "cashflow_months"),
           let decoded = try? JSONDecoder().decode([MonthlyCashflow].self, from: data),
           decoded.count == 2 {
            _currentMonth = State(initialValue: decoded[0])
            _nextMonth = State(initialValue: decoded[1])
        } else {
            _currentMonth = State(initialValue:
                MonthlyCashflow(
                    monthName: thisMonthName,
                    firstHalf: CashflowPeriod(name: "First Half", incomes: [], expenses: []),
                    secondHalf: CashflowPeriod(name: "Second Half", incomes: [], expenses: [])
                )
            )
            _nextMonth = State(initialValue:
                MonthlyCashflow(
                    monthName: nextMonthName,
                    firstHalf: CashflowPeriod(name: "First Half", incomes: [], expenses: []),
                    secondHalf: CashflowPeriod(name: "Second Half", incomes: [], expenses: [])
                )
            )
        }

        _allSources = State(initialValue: store.load([IncomeSource].self, forKey: "income_sources") ?? [])
        _allAccounts = State(initialValue: store.load([Account].self, forKey: "accounts") ?? [])
        
        // Make TabBar solid
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground() // makes it solid
            tabBarAppearance.backgroundColor = UIColor.systemBackground // or any color you want
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }

    var body: some View {
        TabView {
            NavigationStack {
                monthView(for: $currentMonth)
                    //.navigationTitle(currentMonth.monthName)
                    //.navigationBarTitleDisplayMode(.large)
                    .navigationTitle("")        // hide navigation title
                    .navigationBarHidden(true)
            }
            .tabItem {
                Label("This Month", systemImage: "calendar")
            }

            NavigationStack {
                monthView(for: $nextMonth)
                    .navigationTitle(nextMonth.monthName)
                    .navigationBarTitleDisplayMode(.large)
            }
            .tabItem {
                Label("Next Month", systemImage: "calendar.badge.plus")
            }
        }
        .onDisappear {
            saveMonths()
        }
    }

    private func monthView(for month: Binding<MonthlyCashflow>) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Month header
            Text(month.wrappedValue.monthName)
                .font(.largeTitle)
                .bold()
                .padding(.horizontal)
                .padding(.top, 16)
                .padding(.bottom, 8)

            List {
                PeriodSection(
                    period: Binding(
                        get: { month.wrappedValue.firstHalf },
                        set: { month.wrappedValue.firstHalf = $0 }
                    ),
                    allSources: allSources,
                    allAccounts: allAccounts
                )

                PeriodSection(
                    period: Binding(
                        get: { month.wrappedValue.secondHalf },
                        set: { month.wrappedValue.secondHalf = $0 }
                    ),
                    allSources: allSources,
                    allAccounts: allAccounts
                )

                summarySection(for: month.wrappedValue)
                manageSection
            }
            .listStyle(.insetGrouped)
        }
    }

    private func summarySection(for month: MonthlyCashflow) -> some View {
        let totalIncome = month.firstHalf.totalIncome + month.secondHalf.totalIncome
        let totalExpenses = month.firstHalf.totalExpenses + month.secondHalf.totalExpenses
        let balance = totalIncome - totalExpenses

        return Section(header: Text("Summary").font(.headline)) {
            HStack {
                Text("Total Income")
                Spacer()
                Text(totalIncome, format: .currency(code: "PHP"))
            }
            HStack {
                Text("Total Expenses")
                Spacer()
                Text(totalExpenses, format: .currency(code: "PHP"))
            }
            HStack {
                Text("Balance")
                Spacer()
                Text(balance, format: .currency(code: "PHP"))
                    .foregroundColor(balance >= 0 ? .secondary : .red)
            }
        }
    }

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
        }
    }

    private func saveMonths() {
        let months = [currentMonth, nextMonth]
        if let encoded = try? JSONEncoder().encode(months) {
            UserDefaults.standard.set(encoded, forKey: "cashflow_months")
        }
    }
}


// MARK: - Preview
#Preview {
    ContentView()
}
