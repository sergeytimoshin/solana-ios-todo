//
//  ContentView.swift
//  ios-todo-app
//
//  Created by Sergey Timoshin on 29/06/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var todosController = TodosController()

    var body: some View {
        ZStack {
            TodoList(controller: todosController)          
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
