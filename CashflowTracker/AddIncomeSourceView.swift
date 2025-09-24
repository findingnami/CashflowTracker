//
//  AddIncomeSourceView.swift
//  CashflowTracker
//
//  Created by Maria Rachel on 9/15/25.
//

import SwiftUI

struct AddIncomeSourceView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    
    var onSave: (IncomeSource) -> Void

    var body: some View {
        
        VStack {
            TextField("Income Source", text: $name)
                .textFieldStyle(.roundedBorder)

            HStack {
                Button("Cancel") {
                    dismiss()
                }
                
                Spacer()
                
                Button("Save") {
                    onSave(IncomeSource(name: name))
                    dismiss()
                }
            }
            
            
        }
        .padding()
        
    }
}

#Preview {
    NavigationStack {
        AddIncomeSourceView{_ in}
    }
}

