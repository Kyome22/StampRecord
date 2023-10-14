/*
 SelectEmojiButtonStyle.swift
StampRecord

 Created by Takuto Nakamura on 2023/09/10.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct SelectEmojiButtonStyle<Content: View>: ButtonStyle {
    let transform: (SelectEmojiLabel) -> Content

    init(@ViewBuilder transform: @escaping (SelectEmojiLabel) -> Content) {
        self.transform = transform
    }

    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 16) {
            transform(SelectEmojiLabel(configuration: configuration))
                .padding(8)
                .overlay(alignment: .trailing) {
                    Rectangle()
                        .fill(Color(.cellBorder))
                        .frame(width: 1)
                }
            Text("selectEmoji")
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color(.appBackground).opacity(configuration.isPressed ? 0.5 : 0.0))
        .cornerRadius(8)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(.cellBorder), lineWidth: 1)
        }
    }
}

struct SelectEmojiLabel: View {
    let configuration: ButtonStyle.Configuration

    var body: some View {
        configuration.label
            .font(.largeTitle)
            .padding(8)
    }
}

// extension ButtonStyle {
//     static func selectEmojiButton<Content: View>(
//         @ViewBuilder transform: @escaping (SelectEmojiLabel) -> Content
//     ) -> SelectEmojiButtonStyle<Content> where Self == SelectEmojiButtonStyle<Content> {
//         return SelectEmojiButtonStyle<Content>(transform: transform)
//     }
// }
