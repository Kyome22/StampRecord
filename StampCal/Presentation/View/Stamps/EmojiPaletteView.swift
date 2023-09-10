/*
 EmojiPaletteView.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/10.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct EmojiPaletteView: View {
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]

    var body: some View {
        VStack {
            Text("selectEmoji")
            Divider()
            LazyVGrid(columns: columns) {
                
            }
        }
    }
}

struct EmojiPaletteView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiPaletteView()
    }
}
