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
    associatedtype TR: TodayRepository
    associatedtype SVM: StampsViewModel
    associatedtype DVM: DayCalendarViewModel
    associatedtype WVM: WeekCalendarViewModel
    associatedtype MVM: MonthCalendarViewModel
    associatedtype SeVM: SettingsViewModel

    var device: Device { get set }
    var tabSelection: Tab { get set }
    var defaultPeriod: Period { get set }
    var coreDataRepository: CoreDataRepository { get }
    var stampRepository: SR { get }
    var logRepository: LR { get }
    var todayRepository: TR { get }
}

final class StampRecordAppModelImpl: StampRecordAppModel {
    typealias SR = StampRepositoryImpl
    typealias LR = LogRepositoryImpl
    typealias TR = TodayRepositoryImpl
    typealias SVM = StampsViewModelImpl
    typealias DVM = DayCalendarViewModelImpl
    typealias WVM = WeekCalendarViewModelImpl
    typealias MVM = MonthCalendarViewModelImpl
    typealias SeVM = SettingsViewModelImpl

    @Published var device: Device = .default
    @Published var tabSelection: Tab = .dayCalendar
    @AppStorage(.defaultPeriod) var defaultPeriod: Period = .day

    let coreDataRepository: CoreDataRepository
    let stampRepository: SR
    let logRepository: LR
    let todayRepository: TR

    init() {
        let isTesting = ProcessInfo.isUnitTesting || ProcessInfo.isUITesting
        coreDataRepository = isTesting ? .init(inMemory: true) : .shared
        let context = ManagedObjectContextImpl(context: coreDataRepository.container.viewContext)
        stampRepository = SR(context: context)
        logRepository = LR(context: context, stampsPublisher: stampRepository.stampsPublisher)
        todayRepository = TR()

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
        typealias TR = TodayRepositoryMock
        typealias SVM = StampsViewModelMock
        typealias DVM = DayCalendarViewModelMock
        typealias WVM = WeekCalendarViewModelMock
        typealias MVM = MonthCalendarViewModelMock
        typealias SeVM = SettingsViewModelMock

        @Published var device: Device = .default
        @Published var tabSelection: Tab = .dayCalendar
        @Published var defaultPeriod: Period = .day

        let coreDataRepository = CoreDataRepository.mock
        let stampRepository = SR()
        let logRepository = LR()
        let todayRepository = TR()
    }
}
