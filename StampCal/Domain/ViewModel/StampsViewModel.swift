/*
 StampsViewModel.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/08.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

protocol StampsViewModel: ObservableObject {
    associatedtype SR: StampRepository

    var stampOrderBy: StampOrderBy { get set }
    var stampOrderIn: StampOrderIn { get set }
    var stamps: [Stamp] { get set }
    var showingSheet: Bool { get set }
    var targetStamp: Stamp? { get set }

    init(_ stampRepository: SR)

    func sortStamps()
    func addNewStamp(_ emoji: String, _ summary: String) -> Bool
    func updateStamp(_ stamp: Stamp, _ emoji: String, _ summary: String) -> Bool
    func deleteStamp(_ stamp: Stamp)
}

final class StampsViewModelImpl<SR: StampRepository>: StampsViewModel {
    typealias SR = SR

    @Published var stampOrderBy: StampOrderBy = .createdDate
    @Published var stampOrderIn: StampOrderIn = .ascending
    @Published var stamps: [Stamp] = []
    @Published var showingSheet: Bool = false
    @Published var targetStamp: Stamp? = nil

    private let stampRepository: SR

    init(_ stampRepository: SR) {
        self.stampRepository = stampRepository
        stamps = stampRepository.stamps
        sortStamps()
    }

    func sortStamps() {
        stamps = stamps.sorted(by: stampOrderBy, in: stampOrderIn)
    }

    func addNewStamp(_ emoji: String, _ summary: String) -> Bool {
        guard stampRepository.addStamp(emoji, summary) else { return false }
        stamps = stampRepository.stamps
        sortStamps()
        return true
    }

    func updateStamp(_ stamp: Stamp, _ emoji: String, _ summary: String) -> Bool {
        guard stampRepository.updateStamp(stamp, emoji, summary) else { return false }
        stamps = stampRepository.stamps
        sortStamps()
        return true
    }

    func deleteStamp(_ stamp: Stamp) {
        stampRepository.deleteStamp(stamp)
        stamps = stampRepository.stamps
        sortStamps()
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class StampsViewModelMock: StampsViewModel {
        typealias SR = StampRepositoryMock

        @Published var stampOrderBy: StampOrderBy = .createdDate
        @Published var stampOrderIn: StampOrderIn = .ascending
        @Published var stamps: [Stamp] = []
        @Published var showingSheet: Bool = false
        @Published var targetStamp: Stamp? = nil

        init(_ stampRepository: SR) {}
        init() {}

        func sortStamps() {}
        func addNewStamp(_ emoji: String, _ summary: String) -> Bool { return true }
        func updateStamp(_ stamp: Stamp, _ emoji: String, _ summary: String) -> Bool { return true }
        func deleteStamp(_ stamp: Stamp) {}
    }
}
