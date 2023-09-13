/*
 EditStampViewModel.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/13.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

final class EditStampViewModel: ObservableObject {
    @Published var emoji: String = ""
    @Published var summary: String = ""
    @Published var showEmojiPicker: Bool = false
    @Published var showOverlappedError: Bool = false

    private let original: Stamp
    private let overwriteAndSaveStampHandler: (String, Stamp) -> Bool
    private let deleteStampHandler: (String) -> Void

    var disabledDone: Bool {
        if emoji.isEmpty || summary.isEmpty {
            return true
        }
        if emoji == original.emoji && summary == original.summary {
            return true
        }
        return false
    }

    init(
        original: Stamp,
        overwriteAndSaveStampHandler: @escaping (String, Stamp) -> Bool,
        deleteStampHandler: @escaping (String) -> Void
    ) {
        self.original = original
        self.overwriteAndSaveStampHandler = overwriteAndSaveStampHandler
        self.deleteStampHandler = deleteStampHandler
        emoji = original.emoji
        summary = original.summary
    }

    func overriteAndSaveStamp() -> Bool {
        let stamp = Stamp(emoji: emoji, summary: summary, createdDate: original.createdDate)
        let result = overwriteAndSaveStampHandler(original.id, stamp)
        showOverlappedError = !result
        return result
    }

    func deleteStamp() {
        deleteStampHandler(original.id)
    }
}
