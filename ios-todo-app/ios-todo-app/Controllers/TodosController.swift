//
//  TodosController.swift
//  ios-todo-app
//
//  Created by Sergey Timoshin on 29/06/2023.
//

import Foundation
import SwiftUI
import Boutique

final class TodosController: ObservableObject {
    let store: Store<Todo>

    var todos: [Todo] {
        get async {
            await store.items
        }
    }

    init() {
        store = Store<Todo>(
            storage: SQLiteStorageEngine.default(appendingPath: "todo"),
            cacheIdentifier: \.id.uuidString
        )
    }

    func add(_ todo: Todo) {
        Task {
            do {
                try await store.insert(todo)
                let solana = await SolanaController()
                if !todo.text.isEmpty {
                    await solana.addTodo(todo.text)
                }
            } catch {
                print(error)
            }
        }
    }

    func update(_ todo: Todo) {
        Task {
            do {
                try await store.insert(todo)
                let solana = await SolanaController()
                if !todo.text.isEmpty {
                    await solana.addTodo(todo.text)
                }
            } catch {
                print(error)
            }
        }
    }

    func updateAll(_ todos: [Todo]) {
        Task {
            do {
                try await store.insert(todos)
            } catch {
                print(error)
            }
        }
    }

    func remove(_ todo: Todo) {
        Task {
            do {
                try await store.remove(todo)
            } catch {
                print(error)
            }
        }
    }
}
