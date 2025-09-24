//
//  AllocationSectionView.swift
//  CashflowTracker
//
//  Created by Maria Rachel on 9/16/25.
//

import SwiftUI


struct AllocationSectionView: View {
    var allocations: [Allocation]

    var body: some View {
        Section(header: Text("Account Allocation")) {   // ✅ explicit header
            ForEach(allocations) { allocation in        // ✅ no id: needed if Identifiable
                HStack {
                    Text("\(allocation.account)")           // use .rawValue only if enum
                    Spacer()
                    Text(allocation.total,
                         format: .currency(code: "PHP"))
                }
            }
        }
    }
}
