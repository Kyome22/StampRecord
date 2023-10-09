/*
 StampView.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/24.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

// ボツ
struct StampView: View {
    @State var width: CGFloat = .zero
    let emoji: String
    let summary: String
    let size: CGFloat
    let ratio: CGFloat

    init(emoji: String, summary: String, size: CGFloat = 160) {
        self.emoji = emoji
        self.summary = summary
        self.size = size
        self.ratio = size / 320
    }

    var body: some View {
        ZStack {
            Text(emoji)
                .font(.system(size: ratio * 150))
            Image(.stampLabel)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
            Image(.stampBase)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color(.cellBlue))
            Text(summary)
                .font(.system(size: ratio * 30, weight: .semibold))
                .lineLimit(1)
                .foregroundColor(Color(.cellBlue))
                .background {
                    GeometryReader { geometry in
                        Color.clear.preference(
                            key: WidthPreferenceKey.self,
                            value: geometry.size.width
                        )
                    }
                }
                .scaleEffect(x: min(1, 100 / width))
                .position(x: 0.5 * size, y: ratio * 252)
        }
        .frame(width: size, height: size)
        .onPreferenceChange(WidthPreferenceKey.self) { width in
            self.width = width
        }
    }
}

#Preview {
    StampView(emoji: "🍽️", summary: "皿洗い")
}
