//
//  TodoList.swift
//  ios-todo-app
//
//  Created by Sergey Timoshin on 29/06/2023.
//

import SwiftUI

struct TodoList: View {
    @State private var showingSheet = false

    @StateObject var solana = SolanaController()

    @ObservedObject var controller: TodosController
    @FocusState var focusedTodoID: UUID?

    @State private var todos: [Todo] = []

    var body: some View {
        ZStack {
            List {
                ForEach(todos) { todo in
                    TodoRow(todo: todoRowBinding(todo))
                        .listRowSeparator(.hidden)
                        .focused($focusedTodoID, equals: todo.id)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive, action: {
                                withAnimation {
                                    controller.remove(todo)
                                }
                            }) {
                                Label("Delete Todo", systemImage: "trash")
                            }
                        }
                }
                .onMove { from, to in
                    move(todos: &todos, from: from, to: to)
                    controller.updateAll(todos)
                }
            }
            .scrollDismissesKeyboard(.immediately)
            .listStyle(.plain)


            Button(action: {
                let newTodo = Todo("")
                withAnimation {
                    controller.add(newTodo)
                    focusedTodoID = newTodo.id
                }
            }) {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .bold()
                    .padding()
                    .background(
                        Circle().fill(Color.accentColor)
                    )
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom)

            HStack {
                Spacer()
                Button(action: {
                    showingSheet.toggle()
                }) {
                    Image(systemName: "gear")
                        .foregroundColor(Color.accentColor)
                        .bold()
                        .imageScale(.large)

                }
                .sheet(isPresented: $showingSheet) {
                    SolanaSettings()
                }
                .padding(.trailing)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.bottom)
        }
        .onReceive(controller.store.$items) { todos in
            self.todos = todos.sorted()
        }
    }

    private func todoRowBinding(_ todo: Todo) -> Binding<Todo> {
        .init(get: {
            todo
        }, set: { mutatedTodo in
            let isToggleChange = mutatedTodo.isCompleted != todo.isCompleted
            if isToggleChange {
                handleToggleChange(mutatedTodo)
            } else {
                controller.update(mutatedTodo)                
            }
        })
    }

    private func move(todos: inout [Todo], from source: IndexSet, to destination: Int) {
        todos.move(fromOffsets: source, toOffset: destination)
        todos.indices.forEach {
            todos[$0].sortOrder = $0
        }
    }

    private func handleToggleChange(_ todo: Todo) {
        guard let originalIndex = todos.firstIndex(where: { $0.id == todo.id }) else {
            fatalError()
        }

        var copy = todos
        copy[originalIndex] = todo

        for index in copy.indices.reversed() where index != originalIndex {
            if copy[index].isCompleted {
                continue
            }
            move(todos: &copy, from: .init(integer: originalIndex), to: index + 1)
            break
        }

        withAnimation {
            todos = copy
            controller.updateAll(todos)
        }
    }
}

struct TodoList_Previews: PreviewProvider {
    struct DemoView: View {
        @StateObject var controller = TodosController()
        var body: some View {
            TodoList(controller: controller)
        }
    }
    static var previews: some View {
        DemoView()
    }
}

