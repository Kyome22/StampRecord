/*
 StampsViewModel.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/08.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

final class StampsViewModel: ObservableObject {
    @Published var stamps: [Stamp] = Stamp.dummy
    @Published var showingSheet: Bool = false

    init() {}

    func addNewStamp(_ stamp: Stamp) -> Bool {
        // TODO: idを後で修正する
        if stamps.contains(where: { $0.emoji == stamp.emoji }) {
            return false
        }
        stamps.insert(stamp, at: 0)
        return true
    }

    func deleteStamp() {

    }
}
