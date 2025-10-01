//
//  CashflowPeriod.swift
//  CashflowTracker
//
//  Created by Maria Rachel on 9/14/25.
//

import Foundation

struct CashflowPeriod: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var incomes: [Income]
    var expenses: [Expense]
    
    var totalIncome: Double {
        incomes.reduce(0) { $0 + $1.amount }
    }
    
    var totalExpenses: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
    
    var remaining: Double {
        totalIncome - totalExpenses
    }
    
    var allocations: [Allocation] {
        Dictionary(grouping: expenses, by: { $0.account })
            .map { (account, expenses) in
                Allocation(account: account, total: expenses.reduce(0) { $0 + $1.amount})
            }
    }
}
