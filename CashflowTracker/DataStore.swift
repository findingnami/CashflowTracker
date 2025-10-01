//
//  DataStore.swift
//  CashflowTracker
//
//  Created by Maria Rachel on 9/30/25.
//

import Foundation

final class DataStore {
    private let periodsKey = "cashflow_periods"
    private let sourcesKey = "income_sources"
    private let accountsKey = "accounts"

    private let defaults = UserDefaults.standard

    func save<T: Codable>(_ value: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(value) {
            defaults.set(data, forKey: key)
        }
    }

    func load<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = defaults.data(forKey: key),
              let value = try? JSONDecoder().decode(type, from: data) else {
            return nil
        }
        return value
    }
}
