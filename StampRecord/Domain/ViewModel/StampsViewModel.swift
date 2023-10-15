/*
 StampsViewModel.swift
StampRecord

 Created by Takuto Nakamura on 2023/09/08.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation
import Combine

protocol StampsViewModel: ObservableObject {
    associatedtype SR: StampRepository

    var stampOrderBy: StampOrderBy { get set }
    var stampOrderIn: StampOrderIn { get set }
    var stamps: [Stamp] { get set }
    var showingSheet: Bool { get set }
    var selectedStamp: Stamp? { get set }

    init(_ stampRepository: SR)

    func sortStamps()
    func addNewStamp(_ emoji: String, _ summary: String) throws
    func updateStamp(_ stamp: Stamp, _ emoji: String, _ summary: String) throws
    func deleteStamp(_ stamp: Stamp) throws
}

final class StampsViewModelImpl<SR: StampRepository>: StampsViewModel {
    typealias SR = SR

    @Published var stampOrderBy: StampOrderBy = .createdDate
    @Published var stampOrderIn: StampOrderIn = .ascending
    @Published var stamps: [Stamp] = []
    @Published var showingSheet: Bool = false
    @Published var selectedStamp: Stamp? = nil

    private let stampRepository: SR
    private var cancellables = Set<AnyCancellable>()

    init(_ stampRepository: SR) {
        self.stampRepository = stampRepository

        stampRepository.stampsPublisher
            .sink { [weak self] stamps in
                guard let self else { return }
                self.stamps = stamps.sorted(by: stampOrderBy, in: stampOrderIn)
            }
            .store(in: &cancellables)
    }

    func sortStamps() {
        stamps = stamps.sorted(by: stampOrderBy, in: stampOrderIn)
    }

    func addNewStamp(_ emoji: String, _ summary: String) throws {
        try stampRepository.addStamp(emoji, summary)
    }

    func updateStamp(_ stamp: Stamp, _ emoji: String, _ summary: String) throws {
        try stampRepository.updateStamp(stamp, emoji, summary)
    }

    func deleteStamp(_ stamp: Stamp) throws {
        try stampRepository.deleteStamp(stamp)
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
        @Published var selectedStamp: Stamp? = nil

        init(_ stampRepository: SR) {}
        init() {}

        func sortStamps() {}
        func addNewStamp(_ emoji: String, _ summary: String) throws {}
        func updateStamp(_ stamp: Stamp, _ emoji: String, _ summary: String) throws {}
        func deleteStamp(_ stamp: Stamp) throws {}
    }
}
