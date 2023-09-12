/*
 AddNewStampViewModel.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/10.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation
import EmojiPalette

final class AddNewStampViewModel: ObservableObject {
    @Published var emoji: String = ""
    @Published var summary: String = ""
    @Published var showEmojiPicker: Bool = false
    @Published var showOverlappedError: Bool = false

    private let addNewStampHandler: (Stamp) -> Bool

    init(addNewStampHandler: @escaping (Stamp) -> Bool) {
        self.addNewStampHandler = addNewStampHandler

        let categories: [EmojiCategory] = [.animalsAndNature, .foodAndDrink, .activity, .objects]
        emoji = EmojiParser.shared.randomEmoji(categories: categories).character
    }

    func addNewStamp() -> Bool {
        let result = addNewStampHandler(Stamp(emoji: emoji, summary: summary))
        showOverlappedError = !result
        return result
    }
}
