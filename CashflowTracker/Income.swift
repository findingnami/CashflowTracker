//
//  Income.swift
//  CashflowTracker
//
//  Created by Maria Rachel on 9/14/25.
//

import Foundation

/*enum IncomeSource: String, CaseIterable, Codable {
    case uncommonEdge = "Uncommon Edge"
    case studioTradizo = "Studio Tradizo"
    case joseph = "Joseph"
    case justin = "Justin"
} */

struct IncomeSource: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    
    init(id: UUID = UUID(), name: String) {
            self.id = id
            self.name = name
        }
}

struct Income: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var source: String
    var amount: Double
    var isReceived: Bool = false
}

