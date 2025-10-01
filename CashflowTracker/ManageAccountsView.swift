//
//  ManageAccountsView.swift
//  CashflowTracker
//
//  Created by Maria Rachel on 9/30/25.
//

import SwiftUI

struct ManageAccountsView: View {
    @Binding var accounts: [Account]

    var body: some View {
        List {
            ForEach($accounts) { $account in
                TextField("Account Name", text: $account.name)
            }
            .onDelete { indexSet in
                accounts.remove(atOffsets: indexSet)
            }
        }
        .navigationTitle("Accounts")
    }
}
