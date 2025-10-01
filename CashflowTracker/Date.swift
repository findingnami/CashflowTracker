//
//  Date.swift
//  CashflowTracker
//
//  Created by Maria Rachel on 9/30/25.
//

import Foundation

extension Date {
    func monthNameAndYear() -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "MMMM yyyy"
        return fmt.string(from: self)
    }
}
