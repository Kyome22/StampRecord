/*
 SelectEmojiButtonStyle.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/10.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct SelectEmojiButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 16) {
            configuration.label
                .font(.largeTitle)
                .padding(16)
                .background(SCColor.appBackground)
            Text("selectEmoji")
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(SCColor.appBackground.opacity(configuration.isPressed ? 0.5 : 0.0))
        .cornerRadius(8)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(SCColor.cellBorder, lineWidth: 1)
        }
    }
}

extension ButtonStyle where Self == SelectEmojiButtonStyle {
    static var selectEmoji: SelectEmojiButtonStyle {
        return SelectEmojiButtonStyle()
    }
}
