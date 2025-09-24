//
//  MonthlyCashflow.swift
//  CashflowTracker
//
//  Created by Maria Rachel on 9/14/25.
//

import Foundation

struct MonthlyCashflow: Identifiable {
    let id = UUID()
    let monthName: String
    var firstHalf: CashflowPeriod
    var secondHalf: CashflowPeriod
}
