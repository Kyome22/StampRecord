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

    private let doneEditStampHandler: (Stamp) -> Bool
    private let deleteStampHandler: () -> Void

    init(
        originalStamp: Stamp,
        doneEditStampHandler: @escaping (Stamp) -> Bool,
        deleteStampHandler: @escaping () -> Void
    ) {
        emoji = originalStamp.emoji
        summary = originalStamp.summary
        self.doneEditStampHandler = doneEditStampHandler
        self.deleteStampHandler = deleteStampHandler
    }

    func doneEditStamp() -> Bool {
        let result = doneEditStampHandler(Stamp(emoji: emoji, summary: summary))
        showOverlappedError = !result
        return result
    }

    func deleteStamp() {
        deleteStampHandler()
    }
}
