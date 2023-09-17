/*
 StampRepository.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/17.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

protocol StampRepository: AnyObject {
    var stamps: [Stamp] { get }
    func addStamp(_ stamp: Stamp) -> Bool
    func updateStamp(_ id: String, _ stamp: Stamp) -> Bool
    func deleteStamp(_ id: String)
}

final class StampRepositoryImpl: StampRepository {
    private var _stamps = [Stamp]()

    init() {
        _stamps = Stamp.dummy
    }

    var stamps: [Stamp] {
        return _stamps
    }

    func addStamp(_ stamp: Stamp) -> Bool {
        if stamps.contains(where: { $0.id == stamp.id }) {
            return false
        }
        _stamps.append(stamp)
        return true
    }

    func updateStamp(_ id: String, _ stamp: Stamp) -> Bool {
        guard let index = stamps.firstIndex(where: { $0.id == id }) else {
            return false
        }
        _stamps[index] = stamp
        return true
    }

    func deleteStamp(_ id: String) {
        if let index = stamps.firstIndex(where: { $0.id == id }) {
            _stamps.remove(at: index)
        }
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class StampRepositoryMock: StampRepository {
        let stamps: [Stamp] = []
        func addStamp(_ stamp: Stamp) -> Bool { return true }
        func updateStamp(_ id: String, _ stamp: Stamp) -> Bool { return true }
        func deleteStamp(_ id: String) {}
    }
}
