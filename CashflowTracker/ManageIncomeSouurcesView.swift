//
//  ManageIncomeSouurcesView.swift
//  CashflowTracker
//
//  Created by Maria Rachel on 9/30/25.
//

import SwiftUI

struct ManageIncomeSourcesView: View {
    @Binding var sources: [IncomeSource]

    var body: some View {
        List {
            ForEach($sources) { $source in
                TextField("Source Name", text: $source.name)
            }
            .onDelete { indexSet in
                sources.remove(atOffsets: indexSet)
            }
        }
        .navigationTitle("Income Sources")
    }
}
