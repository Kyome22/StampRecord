/*
 EditStampViewModel.swift
StampRecord

 Created by Takuto Nakamura on 2023/09/13.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

protocol EditStampViewModel: ObservableObject {
    var emoji: String { get set }
    var summary: String { get set }
    var showEmojiPicker: Bool { get set }
    var showDeleteConfirmation: Bool { get set }
    var showErrorAlert: Bool { get set }
    var srError: SRError? { get set }
    var disabledDone: Bool { get }

    init(original: Stamp,
         updateStampHandler: @escaping (Stamp, String, String) throws -> Void,
         deleteStampHandler: @escaping (Stamp) throws -> Void)

    func updateStamp(callback: @escaping () -> Void)
    func deleteStamp(callback: @escaping () -> Void)
}

final class EditStampViewModelImpl: EditStampViewModel {
    @Published var emoji: String = ""
    @Published var summary: String = ""
    @Published var showEmojiPicker: Bool = false
    @Published var showDeleteConfirmation: Bool = false
    @Published var showErrorAlert: Bool = false
    @Published var srError: SRError? = nil

    private let original: Stamp
    private let updateStampHandler: (Stamp, String, String) throws -> Void
    private let deleteStampHandler: (Stamp) throws -> Void

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
        updateStampHandler: @escaping (Stamp, String, String) throws -> Void,
        deleteStampHandler: @escaping (Stamp) throws -> Void
    ) {
        self.original = original
        self.updateStampHandler = updateStampHandler
        self.deleteStampHandler = deleteStampHandler
        emoji = original.emoji
        summary = original.summary
    }

    func updateStamp(callback: @escaping () -> Void) {
        do {
            try updateStampHandler(original, emoji, summary)
            callback()
        } catch let error as SRError {
            srError = error
            showErrorAlert = true
        } catch {}
    }

    func deleteStamp(callback: @escaping () -> Void) {
        do {
            try deleteStampHandler(original)
            callback()
        } catch let error as SRError {
            srError = error
            showErrorAlert = true
        } catch {}
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class EditStampViewModelMock: EditStampViewModel {
        @Published var emoji: String = ""
        @Published var summary: String = ""
        @Published var showEmojiPicker: Bool = false
        @Published var showDeleteConfirmation: Bool = false
        @Published var showErrorAlert: Bool = false
        @Published var srError: SRError? = nil
        let disabledDone: Bool = false

        init(original: Stamp,
             updateStampHandler: @escaping (Stamp, String, String) throws -> Void,
             deleteStampHandler: @escaping (Stamp) throws -> Void) {}
        init() {}

        func updateStamp(callback: @escaping () -> Void) {}
        func deleteStamp(callback: @escaping () -> Void) {}
    }
}
