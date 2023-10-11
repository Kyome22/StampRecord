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

    init(addStampHandler: @escaping (String, String) -> Bool)

    func addNewStamp() -> Bool
}

final class AddNewStampViewModelImpl: AddNewStampViewModel {
    @Published var emoji: String = ""
    @Published var summary: String = ""
    @Published var showEmojiPicker: Bool = false
    @Published var showOverlappedError: Bool = false

    private let addStampHandler: (String, String) -> Bool

    init(addStampHandler: @escaping (String, String) -> Bool) {
        self.addStampHandler = addStampHandler

        let categories: [EmojiCategory] = [.animalsAndNature, .foodAndDrink, .activity, .objects]
        emoji = EmojiParser.shared.randomEmoji(categories: categories).character
    }

    func addNewStamp() -> Bool {
        let result = addStampHandler(emoji, summary)
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

        init(addStampHandler: @escaping (String, String) -> Bool) {}
        init() {}

        func addNewStamp() -> Bool { return true }
    }
}
