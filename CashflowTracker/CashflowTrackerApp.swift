//
//  CashflowTrackerApp.swift
//  CashflowTracker
//

import SwiftUI

@main
struct CashflowTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                // ContentView no longer requires a periods argument
                ContentView()
                    .tint(Color("Sage"))
            }
        }
    }
}
