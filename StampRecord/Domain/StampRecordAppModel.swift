/*
 StampRecordAppModel.swift
 StampRecord

 Created by Takuto Nakamura on 2023/10/14.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI
import CoreData

protocol StampRecordAppModel: ObservableObject {
    associatedtype SR: StampRepository
    associatedtype LR: LogRepository

    var tabSelection: Tab { get set }
    var defaultPeriod: Period { get set }
    var coreDataRepository: CoreDataRepository { get }
    var stampRepository: SR { get }
    var logRepository: LR { get }
}

final class StampRecordAppModelImpl: StampRecordAppModel {
    typealias SR = StampRepositoryImpl
    typealias LR = LogRepositoryImpl

    @Published var tabSelection: Tab = .dayCalendar
    @AppStorage(.defaultPeriod) var defaultPeriod: Period = .day

    let coreDataRepository: CoreDataRepository
    let stampRepository: SR
    let logRepository: LR

    init() {
        let isTesting = ProcessInfo.isUnitTesting || ProcessInfo.isUITesting
        coreDataRepository = isTesting ? .init(inMemory: true) : .shared
        let context = ManagedObjectContextImpl(context: coreDataRepository.container.viewContext)
        stampRepository = SR(context: context)
        logRepository = LR(context: context, stampsPublisher: stampRepository.stampsPublisher)

        if stampRepository.isEmpty {
            tabSelection = .stamps
        } else {
            tabSelection = defaultPeriod.tab
        }
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class StampRecordAppModelMock: StampRecordAppModel {
        typealias SR = StampRepositoryMock
        typealias LR = LogRepositoryMock

        @Published var tabSelection: Tab = .dayCalendar
        @Published var defaultPeriod: Period = .day

        let coreDataRepository = CoreDataRepository.mock
        let stampRepository = SR()
        let logRepository = LR()
    }
}
