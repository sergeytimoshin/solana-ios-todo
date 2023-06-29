//
//  TodoRow.swift
//  ios-todo-app
//
//  Created by Sergey Timoshin on 29/06/2023.
//


import SwiftUI

struct TodoRow: View {
    @Binding var todo: Todo

    var body: some View {
        HStack {
            Checkbox(isChecked: $todo.isCompleted)
            TextField("Todo", text: $todo.text)
                .strikethrough(todo.isCompleted)
                .foregroundColor(todo.isCompleted ? .secondary : .primary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
    }
}

struct TodoRow_Previews: PreviewProvider {

    struct DemoView: View {
        @State var todo = Todo("Get the groceries")
        var body: some View {
            TodoRow(todo: $todo)
        }
    }

    static var previews: some View {
        Group {
            DemoView()
                .previewLayout(.fixed(width: 375, height: 160))
        }
    }
}
