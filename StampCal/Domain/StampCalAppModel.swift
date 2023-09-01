/*
 StampCalAppModel.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/20.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

final class StampCalAppModel: ObservableObject {
    let persistenceController: PersistenceController

    init() {
        self.persistenceController = PersistenceController.shared
    }
}
