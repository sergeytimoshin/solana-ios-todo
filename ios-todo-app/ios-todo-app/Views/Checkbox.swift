//
//  Checkbox.swift
//  ios-todo-app
//
//  Created by Sergey Timoshin on 29/06/2023.
//

import SwiftUI

struct Checkbox: View {
    @Binding var isChecked: Bool

    private let size: CGFloat = 30

    var body: some View {
        Button(action: {
            withAnimation(.default.speed(2)) {
                isChecked.toggle()
            }
        }) {
            rectangleShape
                .fill(
                    isChecked ? Color.accentColor : Color.clear
                )
                .overlay(
                    rectangleShape
                        .strokeBorder(lineWidth: 3)
                        .foregroundColor(isChecked ? Color.accentColor : Color.secondary)
                )
                .overlay(checkmark)
                .background(
                    rectangleShape
                        .shadow(radius: 3)
                        .opacity(isChecked ? 1 : 0)
                    )
                .scaleEffect(isChecked ? 1 : 0.95)
                .frame(width: size, height: size)
        }
        .buttonStyle(CheckboxButtonStyle())
    }

    private var rectangleShape: some InsettableShape {
        RoundedRectangle(cornerRadius: 6, style: .continuous)
    }

    private var checkmark: some View {
        Image(systemName: "checkmark")
            .resizable()
            .bold()
            .padding(5)
            .foregroundColor(.white)
            .opacity(isChecked ? 1 : 0)
    }
}

struct CheckboxButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

struct Checkbox_Previews: PreviewProvider {
    struct DemoView: View {
        @State var isChecked: Bool
        var body: some View {
            Checkbox(isChecked: $isChecked)
        }
    }
    static var previews: some View {
        VStack(spacing: 30) {
            DemoView(isChecked: true)
            DemoView(isChecked: false)
        }
    }
}

