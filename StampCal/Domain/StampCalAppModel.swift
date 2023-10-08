/*
 StampCalAppModel.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/20.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation
import ActivityKit

protocol StampCalAppModel: ObservableObject {
    associatedtype SR: StampRepository
    associatedtype LR: LogRepository

    var tabSelection: Tabs { get set }
    var stampRepository: SR { get }
    var logRepository: LR { get }
}

final class StampCalAppModelImpl: StampCalAppModel {
    typealias SR = StampRepositoryImpl
    typealias LR = LogRepositoryImpl

    @Published var tabSelection: Tabs = .weekCalendar

    let stampRepository = SR()
    let logRepository = LR()

    init() {}
}

// MARK: - Preview Mock
extension PreviewMock {
    final class StampCalAppModelMock: StampCalAppModel {
        typealias SR = StampRepositoryMock
        typealias LR = LogRepositoryMock

        @Published var tabSelection: Tabs = .dayCalendar

        let stampRepository = SR()
        let logRepository = LR()
    }
}
