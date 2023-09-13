/*
 StampsViewModel.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/08.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

final class StampsViewModel: ObservableObject {
    @Published var stampOrderBy: StampOrderBy = .createdDate
    @Published var stampOrderIn: StampOrderIn = .ascending
    @Published var stamps: [Stamp] = Stamp.dummy
    @Published var showingSheet: Bool = false
    @Published var targetStamp: Stamp? = nil

    init() {
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
        if stamps.contains(where: { $0.id == stamp.id }) {
            return false
        }
        stamps.insert(stamp, at: 0)
        return true
    }

    func overwriteAndSave(_ id: String, _ stamp: Stamp) -> Bool {
        guard let index = stamps.firstIndex(where: { $0.id == id }) else {
            return false
        }
        stamps[index] = stamp
        return true
    }

    func deleteStamp(_ id: String) {
        if let index = stamps.firstIndex(where: { $0.id == id }) {
            stamps.remove(at: index)
        }
    }
}
