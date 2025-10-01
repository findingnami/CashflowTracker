//
//  Allocation.swift
//  CashflowTracker
//
//  Created by Maria Rachel on 9/16/25.
//
import Foundation

struct Allocation: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var account: String
    var total: Double
    
    init(account: String, total: Double) {
        self.account = account
        self.total = total
    }
}
