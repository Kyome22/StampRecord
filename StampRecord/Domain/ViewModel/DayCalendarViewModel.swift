/*
 DayCalendarViewModel.swift
 StampRecord

 Created by Takuto Nakamura on 2023/09/06.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation
import Combine
import InfinitePaging

protocol DayCalendarViewModel: ObservableObject {
    associatedtype SR: StampRepository
    associatedtype LR: LogRepository

    var title: String { get set }
    var dayList: [Day] { get set }
    var selectedDayID: UUID? { get set }
    var showStampFilter: Bool { get set }
    var showStampPicker: Bool { get set }
    var stamps: [Stamp] { get set }

    init(_ stampRepository: SR, _ logRepository: LR)

    func setDayList()
    func setToday()
    func paging(with pageDirection: PageDirection)
    func updateFilter(state: StampFilterState)
    func toggleFilter(stamp: Stamp)
    func putStamp(stamp: Stamp) throws
    func removeStamp(day: Day, index: Int) throws
}

final class DayCalendarViewModelImpl<SR: StampRepository,
                                     LR: LogRepository>: DayCalendarViewModel {
    typealias SR = SR
    typealias LR = LR

    @Published var title: String = ""
    @Published var dayList: [Day] = []
    @Published var selectedDayID: UUID? = nil
    @Published var showStampFilter: Bool = false
    @Published var showStampPicker: Bool = false
    @Published var stamps: [Stamp] = []

    private let calendar = Calendar.current
    private let stampRepository: SR
    private let logRepository: LR
    private var today = Date.now
    private var cancellables = Set<AnyCancellable>()

    init(_ stampRepository: SR, _ logRepository: LR) {
        self.stampRepository = stampRepository
        self.logRepository = logRepository

        stampRepository.stampsPublisher
            .sink { [weak self] stamps in
                self?.stamps = stamps
            }
            .store(in: &cancellables)

        logRepository.logsPublisher
            .sink { [weak self] _ in
                self?.loadLog()
            }
            .store(in: &cancellables)

        setDayList()
    }

    private func loadLog() {
        dayList.indices.forEach { i in
            dayList[i].log = logRepository.getLog(of: dayList[i].date)
        }
    }

    private func getYesterday(of date: Date) -> Day {
        let yesterday = calendar.date(byAdding: .day, value: -1, to: date)
        return Day(date: yesterday,
                   isToday: calendar.isEqual(a: yesterday, b: today),
                   text: calendar.dayText(of: yesterday),
                   weekday: calendar.weekday(of: yesterday),
                   log: logRepository.getLog(of: yesterday))
    }

    private func getTommorow(of date: Date) -> Day {
        let tommorow = calendar.date(byAdding: .day, value: 1, to: date)
        return Day(date: tommorow,
                   isToday: calendar.isEqual(a: tommorow, b: today),
                   text: calendar.dayText(of: tommorow),
                   weekday: calendar.weekday(of: tommorow),
                   log: logRepository.getLog(of: tommorow))
    }

    func setDayList() {
        today = Date.now
        dayList.removeAll()
        let day = Day(date: today,
                      isToday: true,
                      text: calendar.dayText(of: today),
                      weekday: calendar.weekday(of: today),
                      log: logRepository.getLog(of: today))
        dayList.append(day)
        dayList.insert(getYesterday(of: today), at: 0)
        dayList.append(getTommorow(of: today))
        title = today.title
        selectedDayID = dayList[1].id
    }

    func setToday() {
        let old = today
        today = Date.now
        if calendar.isEqual(a: old, b: today) { return }
        dayList.indices.forEach { i in
            dayList[i].isToday = calendar.isEqual(a: dayList[i].date, b: today)
        }
    }

    func paging(with pageDirection: PageDirection) {
        switch pageDirection {
        case .backward:
            if let baseDate = dayList.first?.date {
                dayList.insert(getYesterday(of: baseDate), at: 0)
                dayList.removeLast()
            }
        case .forward:
            if let baseDate = dayList.last?.date {
                dayList.append(getTommorow(of: baseDate))
                dayList.removeFirst()
            }
        }
        title = dayList[1].date?.title ?? "?"
        selectedDayID = dayList[1].id
        setToday()
    }

    func updateFilter(state: StampFilterState) {
        stampRepository.updateFilter(state: state)
    }

    func toggleFilter(stamp: Stamp) {
        stampRepository.toggleFilter(stamp: stamp)
    }

    func putStamp(stamp: Stamp) throws {
        guard let index = dayList.firstIndex(where: { $0.id == selectedDayID }) else {
            return
        }
        let day = dayList[index]
        if var log = day.log {
            log.stamps.append(stamp)
            try logRepository.updateLog(log)
        } else if let date = day.date {
            let log = Log(date: date, stamps: [stamp])
            try logRepository.updateLog(log)
        }
        dayList[index].log = logRepository.getLog(of: day.date)
    }

    func removeStamp(day: Day, index: Int) throws {
        if var log = day.log {
            log.stamps.remove(at: index)
            try logRepository.updateLog(log)
        }
        if let index = dayList.firstIndex(of: day) {
            dayList[index].log = logRepository.getLog(of: day.date)
        }
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class DayCalendarViewModelMock: DayCalendarViewModel {
        typealias SR = StampRepositoryMock
        typealias LR = LogRepositoryMock

        @Published var title: String = ""
        @Published var dayList: [Day] = []
        @Published var selectedDayID: UUID? = nil
        @Published var showStampFilter: Bool = false
        @Published var showStampPicker: Bool = false
        @Published var stamps: [Stamp] = []

        init(_ stampRepository: SR, _ logRepository: LR) {}
        init() {
            let calendar = Calendar.current
            let today = Date.now
            let day = Day(date: today,
                          isToday: true,
                          text: calendar.dayText(of: today),
                          weekday: calendar.weekday(of: today))
            dayList.append(day)
            title = today.title
        }

        func setDayList() {}
        func setToday() {}
        func paging(with pageDirection: PageDirection) {}
        func updateFilter(state: StampFilterState) {}
        func toggleFilter(stamp: Stamp) {}
        func putStamp(stamp: Stamp) {}
        func removeStamp(day: Day, index: Int) {}
    }
}
