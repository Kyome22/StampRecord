/*
 StampRecordAppModel.swift
 StampRecord

 Created by Takuto Nakamura on 2023/10/14.
 
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
        let isTesting = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil

        coreDataRepository = isTesting ? .mock : .shared
        stampRepository = SR(context: coreDataRepository.container.viewContext)
        logRepository = LR(context: coreDataRepository.container.viewContext,
                           stampsPublisher: stampRepository.stampsPublisher)

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
