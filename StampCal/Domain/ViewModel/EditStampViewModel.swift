/*
 EditStampViewModel.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/13.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

protocol EditStampViewModel: ObservableObject {
    var emoji: String { get set }
    var summary: String { get set }
    var showEmojiPicker: Bool { get set }
    var showOverlappedError: Bool { get set }
    var disabledDone: Bool { get }

    init(original: Stamp,
         updateStampHandler: @escaping (String, Stamp) -> Bool,
         deleteStampHandler: @escaping (String) -> Void)

    func updateStamp() -> Bool
    func deleteStamp()
}

final class EditStampViewModelImpl: EditStampViewModel {
    @Published var emoji: String = ""
    @Published var summary: String = ""
    @Published var showEmojiPicker: Bool = false
    @Published var showOverlappedError: Bool = false

    private let original: Stamp
    private let updateStampHandler: (String, Stamp) -> Bool
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
        updateStampHandler: @escaping (String, Stamp) -> Bool,
        deleteStampHandler: @escaping (String) -> Void
    ) {
        self.original = original
        self.updateStampHandler = updateStampHandler
        self.deleteStampHandler = deleteStampHandler
        emoji = original.emoji
        summary = original.summary
    }

    func updateStamp() -> Bool {
        let stamp = Stamp(emoji: emoji, summary: summary, createdDate: original.createdDate)
        let result = updateStampHandler(original.id, stamp)
        showOverlappedError = !result
        return result
    }

    func deleteStamp() {
        deleteStampHandler(original.id)
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class EditStampViewModelMock: EditStampViewModel {
        @Published var emoji: String = ""
        @Published var summary: String = ""
        @Published var showEmojiPicker: Bool = false
        @Published var showOverlappedError: Bool = false
        let disabledDone: Bool = false

        init(original: Stamp,
             updateStampHandler: @escaping (String, Stamp) -> Bool,
             deleteStampHandler: @escaping (String) -> Void) {}
        init() {}

        func updateStamp() -> Bool { return true }
        func deleteStamp() {}
    }
}
