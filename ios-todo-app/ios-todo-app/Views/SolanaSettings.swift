//
//  SolanaSettings.swift
//  ios-todo-app
//
//  Created by Sergey Timoshin on 29/06/2023.
//

import SwiftUI

struct SolanaSettings: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var solana = SolanaController()

    var body: some View {
        Form {
            Section(header: Text("Wallet address")) {
                Text("Address:").font(.headline)
                if let account = solana.account {
                    Text(account.publicKey.base58EncodedString)
                }
            }

            Section(header: Text("Balance")) {
                if let balance = solana.balance {
                    Text("\(balance / solana.LAMPORTS_PER_SOL) SOL")
                }
                else {
                    Text("0 SOL")
                }
            }

            Button("airdrop SOL") {
                Task {
                    await solana.airdropSol()
                }
            }

            Button("reload balance") {
                Task {
                    await solana.getBalance()
                }
            }

            Button("Close") {
                dismiss()
            }

        }
        .padding()
        .onAppear {
            solana.generateWallet()
            Task {
                await solana.getBalance()
                await solana.airdropSol()
            }
        }
    }

}

struct SolanaSettings_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
