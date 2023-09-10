/*
 EmojiPaletteView.swift
 

 Created by Takuto Nakamura on 2023/09/11.
 
*/

import SwiftUI

final class EmojiPaletteViewModel: ObservableObject {
    @Published var emojiSets: [EmojiSet]
    @Published var selection: EmojiCategory = .smileysAndPeople
    private let parser = EmojiParser()

    init() {
        emojiSets = parser.getEmojiSets()
    }
}

public struct EmojiPaletteView: View {
    @StateObject var viewModel = EmojiPaletteViewModel()
    private let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 8), count: 6)

    public init() {}

    public var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                List {
                    ForEach(viewModel.emojiSets) { emojiSet in
                        Section {
                            LazyVGrid(columns: columns, spacing: 8) {
                                ForEach(emojiSet.emojis) { emoji in
                                    Text(emoji.character)
                                        .font(.title)
                                }
                            }
                        } header: {
                            Text(emojiSet.category.label)
                                .id(emojiSet.category)
                        }
                        .textCase(.none)
                    }
                }
                .listStyle(.plain)
                Divider()
                HStack {
                    ForEach(EmojiCategory.allCases) { emojiCategory in
                        Image(systemName: emojiCategory.imageName)
                            .foregroundColor(viewModel.selection == emojiCategory ? Color.accentColor : .secondary)
                            .frame(maxWidth: .infinity)
                            .onTapGesture {
                                viewModel.selection = emojiCategory
                                withAnimation {
                                    proxy.scrollTo(emojiCategory, anchor: UnitPoint(x: 0, y: 0))
                                }
                            }
                    }
                }
                .padding(8)
            }
        }
        .frame(width: 240, height: 320)
    }
}

struct EmojiPaletteView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiPaletteView()
    }
}
