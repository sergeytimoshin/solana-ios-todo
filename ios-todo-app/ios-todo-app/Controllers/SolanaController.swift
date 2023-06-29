//
//  SolanaController.swift
//  ios-todo-app
//
//  Created by Sergey Timoshin on 29/06/2023.
//

import Foundation
import SwiftUI
import Solana
import SolanaTodo

@MainActor
class SolanaController: ObservableObject {

    let LAMPORTS_PER_SOL: UInt64 = 1000000000

    @Published var account: HotAccount?
    @Published var balance: UInt64?

    var programAccount: HotAccount?
    let programId = SolanaTodo.PROGRAM_ID!

    let solana = Solana(router: NetworkingRouter(endpoint: RPCEndpoint(url: URL(string: "http://localhost:8899")!, urlWebSocket: URL(string: "ws://localhost:8900/")!, network: .devnet)))

    func createOrLoadAccount(_ key: String) -> HotAccount? {
        let phrase: Mnemonic

        let mnemonic = UserDefaults.standard.string(forKey: key)
        if let mnemonic = mnemonic {
            phrase = Mnemonic(phrase: mnemonic.components(separatedBy: ","))!
        }
        else {
            phrase = Mnemonic()
            UserDefaults.standard.set(phrase.phrase.joined(separator: ","), forKey: key)
        }

        return HotAccount(phrase: phrase.phrase)
    }
    func generateWallet() {
        account = createOrLoadAccount("user_account")
        programAccount = createOrLoadAccount("program_account")
    }

    func getBalance() async {
        guard let account = account else { return }
        balance = try! await solana.api.getBalance(account: account.publicKey.base58EncodedString)
    }

    func airdropSol() async {
        guard let account = account else { return }
        do {
            let airdrop = try await solana.api.requestAirdrop(account: account.publicKey.base58EncodedString, lamports: LAMPORTS_PER_SOL)
            print(airdrop)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    func addTodo(_ content: String) async {
        guard let account = account else { return }
        guard let programAccount = programAccount else { return }
        do {
            let accounts = AddTodoInstructionAccounts(todo: programAccount.publicKey, user: account.publicKey, systemProgram: PublicKey.systemProgramId)
            let instruction = createAddTodoInstruction(accounts: accounts, args: AddTodoInstructionArgs(content: content))
            let tx = try await solana.action.serializeAndSendWithFee(
                instructions: [instruction],
                signers: [account, programAccount])
            print(tx)

            Stodo.fromAccountAddress(connection: solana.api, address: programId) { result in
                print(result)
            }
        }
        catch {
            print("Error: \(error.localizedDescription)")
        }
    }

}
