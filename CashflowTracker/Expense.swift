//
//  Expense.swift
//  CashflowTracker
//
//  Created by Maria Rachel on 9/14/25.
//

import Foundation

/* enum Account: String, CaseIterable, Codable {
    case cash = "Cash"
    case bpi = "BPI"
    case gotyme = "GoTyme"
    case gcash = "GCash"
    case seabank = "SeaBank"
    case rbank = "RBank"
    case ubank = "UBank"
} */

struct Account: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
}

struct Expense: Identifiable, Codable {
    var id: UUID = UUID()
    var account: String
    var item: String
    var amount: Double
    var isSpent: Bool = false
}
