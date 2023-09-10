/*
 StampsViewModel.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/08.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

final class StampsViewModel: ObservableObject {
    @Published var stamps: [Stamp] = Stamp.dummy
    @Published var showingSheet: Bool = false

    init() {}

    func addStamp() {

    }

    func deleteStamp() {

    }
}
