//
//  AddAccountView.swift
//  CashflowTracker
//
//  Created by Maria Rachel on 9/15/25.
//

import SwiftUI

struct AddAccountView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    
    var onSave: (Account) -> Void // Callback to send the new account back
    
    var body: some View {
            VStack {
                TextField("Account name", text: $name)
                    .textFieldStyle(.roundedBorder)

                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    
                    Spacer()
                    
                    Button("Save") {
                        onSave(Account(name: name))
                        dismiss()
                    }
                }
            }
            .padding()
        }
}

#Preview {
    NavigationStack {
        AddAccountView{_ in}
    }
}
