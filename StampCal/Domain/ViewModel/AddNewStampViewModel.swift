/*
 AddNewStampViewModel.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/10.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation
import EmojiPalette

protocol AddNewStampViewModel: ObservableObject {
    var emoji: String { get set }
    var summary: String { get set }
    var showEmojiPicker: Bool { get set }
    var showOverlappedError: Bool { get set }

    init(addStampHandler: @escaping (Stamp) -> Bool)

    func addNewStamp() -> Bool
}

final class AddNewStampViewModelImpl: AddNewStampViewModel {
    @Published var emoji: String = ""
    @Published var summary: String = ""
    @Published var showEmojiPicker: Bool = false
    @Published var showOverlappedError: Bool = false

    private let addStampHandler: (Stamp) -> Bool

    init(addStampHandler: @escaping (Stamp) -> Bool) {
        self.addStampHandler = addStampHandler

        let categories: [EmojiCategory] = [.animalsAndNature, .foodAndDrink, .activity, .objects]
        emoji = EmojiParser.shared.randomEmoji(categories: categories).character
    }

    func addNewStamp() -> Bool {
        let stamp = Stamp(emoji: emoji, summary: summary)
        let result = addStampHandler(stamp)
        showOverlappedError = !result
        return result
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class AddNewStampViewModelMock: AddNewStampViewModel {
        @Published var emoji: String = ""
        @Published var summary: String = ""
        @Published var showEmojiPicker: Bool = false
        @Published var showOverlappedError: Bool = false

        init(addStampHandler: @escaping (Stamp) -> Bool) {}
        init() {}

        func addNewStamp() -> Bool { return true }
    }
}
