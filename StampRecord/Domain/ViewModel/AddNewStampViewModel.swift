/*
 AddNewStampViewModel.swift
StampRecord

 Created by Takuto Nakamura on 2023/09/10.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation
import EmojiPalette

protocol AddNewStampViewModel: ObservableObject {
    var emoji: String { get set }
    var summary: String { get set }
    var showEmojiPicker: Bool { get set }
    var showErrorAlert: Bool { get set }
    var srError: SRError? { get set }

    init(addStampHandler: @escaping (String, String) throws -> Void)

    func addNewStamp(callback: @escaping () -> Void)
}

final class AddNewStampViewModelImpl: AddNewStampViewModel {
    @Published var emoji: String = ""
    @Published var summary: String = ""
    @Published var showEmojiPicker: Bool = false
    @Published var showErrorAlert: Bool = false
    @Published var srError: SRError? = nil

    private let addStampHandler: (String, String) throws -> Void

    init(addStampHandler: @escaping (String, String) throws -> Void) {
        self.addStampHandler = addStampHandler

        let categories: [EmojiCategory] = [.animalsAndNature, .foodAndDrink, .activity, .objects]
        emoji = EmojiParser.shared.randomEmoji(categories: categories).character
    }

    func addNewStamp(callback: @escaping () -> Void) {
        do {
            try addStampHandler(emoji, summary)
            callback()
        } catch let error as SRError {
            srError = error
            showErrorAlert = true
        } catch {}
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class AddNewStampViewModelMock: AddNewStampViewModel {
        @Published var emoji: String = ""
        @Published var summary: String = ""
        @Published var showEmojiPicker: Bool = false
        @Published var showErrorAlert: Bool = false
        @Published var srError: SRError? = nil

        init(addStampHandler: @escaping (String, String) throws -> Void) {}
        init() {}

        func addNewStamp(callback: @escaping () -> Void) {}
    }
}
