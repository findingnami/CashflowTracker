//
//  PeriodSection.swift
//  CashflowTracker
//
//  Created by Maria Rachel on 9/17/25.
//

import SwiftUI

struct PeriodSection: View {
    @Binding var period: CashflowPeriod
    let allSources: [IncomeSource]
    let allAccounts: [Account]

    var body: some View {
            // Header itself is a NavigationLink
            Section(
                header:
                    NavigationLink {
                        CashflowPeriodView(
                            period: $period,
                            allSources: allSources,
                            allAccounts: allAccounts
                        )
                    } label: {
                        HStack {
                            Text(period.name)      // big title
                                .font(.headline)
                            Spacer()               // pushes chevron to the far right
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                    }
            ) {
                // Totals only, no “View Details” row
                HStack {
                    Text("Total Income")
                    Spacer()
                    Text(period.totalIncome, format: .currency(code: "PHP"))
                }
                HStack {
                    Text("Total Expenses")
                    Spacer()
                    Text(period.totalExpenses, format: .currency(code: "PHP"))
                }
                HStack {
                    Text("Remaining Balance")
                    Spacer()
                    Text(period.remaining, format: .currency(code: "PHP"))
                        .fontWeight(.semibold)
                }
            }
        }
}
