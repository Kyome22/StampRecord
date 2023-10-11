/*
 StampCalAppModel.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/20.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation
import ActivityKit
import CoreData

protocol StampCalAppModel: ObservableObject {
    associatedtype SR: StampRepository
    associatedtype LR: LogRepository

    var tabSelection: Tabs { get set }
    var coreDataRepository: CoreDataRepository { get }
    var stampRepository: SR { get }
    var logRepository: LR { get }
}

final class StampCalAppModelImpl: StampCalAppModel {
    typealias SR = StampRepositoryImpl
    typealias LR = LogRepositoryImpl

    @Published var tabSelection: Tabs = .dayCalendar

    let coreDataRepository = CoreDataRepository.preview
    let stampRepository: SR
    let logRepository = LR()

    init() {
        stampRepository = SR(context: coreDataRepository.container.viewContext)
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class StampCalAppModelMock: StampCalAppModel {
        typealias SR = StampRepositoryMock
        typealias LR = LogRepositoryMock

        @Published var tabSelection: Tabs = .dayCalendar

        let coreDataRepository = CoreDataRepository.preview
        let stampRepository = SR()
        let logRepository = LR()
    }
}
