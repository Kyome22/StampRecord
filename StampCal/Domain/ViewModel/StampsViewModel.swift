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
    func addNewStamp(_ stamp: Stamp) -> Bool
    func updateStamp(_ id: String, _ stamp: Stamp) -> Bool
    func deleteStamp(_ id: String)
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
        switch (stampOrderBy, stampOrderIn) {
        case (.createdDate, .ascending):
            stamps.sort { $0.createdDate < $1.createdDate }
        case (.createdDate, .descending):
            stamps.sort { $0.createdDate > $1.createdDate }
        case (.summary, .ascending):
            stamps.sort { $0.summary < $1.summary }
        case (.summary, .descending):
            stamps.sort { $0.summary > $1.summary }
        }
    }

    func addNewStamp(_ stamp: Stamp) -> Bool {
        guard stampRepository.addStamp(stamp) else { return false }
        stamps = stampRepository.stamps
        sortStamps()
        return true
    }

    func updateStamp(_ id: String, _ stamp: Stamp) -> Bool {
        guard stampRepository.updateStamp(id, stamp) else { return false }
        stamps = stampRepository.stamps
        sortStamps()
        return true
    }

    func deleteStamp(_ id: String) {
        stampRepository.deleteStamp(id)
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
        @Published var stamps: [Stamp] = Stamp.dummy
        @Published var showingSheet: Bool = false
        @Published var targetStamp: Stamp? = nil

        init(_ stampRepository: SR) {}
        init() {}

        func sortStamps() {}
        func addNewStamp(_ stamp: Stamp) -> Bool { return true }
        func updateStamp(_ id: String, _ stamp: Stamp) -> Bool { return true }
        func deleteStamp(_ id: String) {}
    }
}
