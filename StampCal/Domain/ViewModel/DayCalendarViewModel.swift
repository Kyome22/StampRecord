/*
 DayCalendarViewModel.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/06.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

protocol DayCalendarViewModel: ObservableObject {
    associatedtype SR: StampRepository
    associatedtype LR: LogRepository

    var title: String { get set }
    var dayList: [Day] { get set }
    var selectedDayID: UUID? { get set }
    var showStampPicker: Bool { get set }
    var shortWeekdays: [String] { get }

    init(_ stampRepository: SR, _ logRepository: LR)

    func setDayList()
    func reloadLog()
    func paging(with pageDirection: PageDirection)
    func putStamp(stamp: Stamp)
    func removeStamp(day: Day, index: Int)
}

final class DayCalendarViewModelImpl<SR: StampRepository,
                                     LR: LogRepository>: DayCalendarViewModel {
    typealias SR = SR
    typealias LR = LR

    @Published var title: String = ""
    @Published var dayList: [Day] = []
    @Published var selectedDayID: UUID? = nil
    @Published var showStampPicker: Bool = false

    let shortWeekdays: [String]
    private let calendar = Calendar.current
    private let stampRepository: SR
    private let logRepository: LR
    private var notFirstOnAppear: Bool = false

    init(_ stampRepository: SR, _ logRepository: LR) {
        shortWeekdays = calendar.shortWeekdaySymbols
        self.stampRepository = stampRepository
        self.logRepository = logRepository
        setDayList()
    }

    private func getYesterday(of date: Date) -> Day {
        let yesterday = calendar.date(byAdding: .day, value: -1, to: date)
        return Day(date: yesterday,
                   isToday: calendar.isEqual(a: yesterday, b: Date.now),
                   text: calendar.dayText(of: yesterday),
                   weekday: calendar.weekday(of: yesterday),
                   log: logRepository.getLog(of: yesterday))
    }

    private func getTommorow(of date: Date) -> Day {
        let tommorow = calendar.date(byAdding: .day, value: 1, to: date)
        return Day(date: tommorow,
                   isToday: calendar.isEqual(a: tommorow, b: Date.now),
                   text: calendar.dayText(of: tommorow),
                   weekday: calendar.weekday(of: tommorow),
                   log: logRepository.getLog(of: tommorow))
    }

    func setDayList() {
        dayList.removeAll()
        let now = Date.now
        let day = Day(date: now,
                      isToday: true,
                      text: calendar.dayText(of: now),
                      weekday: calendar.weekday(of: now),
                      log: logRepository.getLog(of: now))
        dayList.append(day)
        dayList.insert(getYesterday(of: now), at: 0)
        dayList.append(getTommorow(of: now))
        title = now.title
        selectedDayID = dayList[1].id
    }

    func reloadLog() {
        if notFirstOnAppear {
            dayList.indices.forEach { i in
                dayList[i].log = logRepository.getLog(of: dayList[i].date)
            }
        } else {
            notFirstOnAppear = true
        }
    }

    func paging(with pageDirection: PageDirection) {
        switch pageDirection {
        case .backward:
            if let baseDate = dayList[pageDirection.baseIndex].date {
                dayList.insert(getYesterday(of: baseDate), at: 0)
                dayList.removeLast()
            }
        case .forward:
            if let baseDate = dayList[pageDirection.baseIndex].date {
                dayList.append(getTommorow(of: baseDate))
                dayList.removeFirst()
            }
        }
        title = dayList[1].date?.title ?? "?"
        selectedDayID = dayList[1].id
    }

    func putStamp(stamp: Stamp) {
        guard let index = dayList.firstIndex(where: { $0.id == selectedDayID }) else {
            return
        }
        let day = dayList[index]
        if var log = day.log {
            log.stamps.append(stamp)
            logRepository.updateLog(log)
        } else if let date = day.date {
            let log = Log(date: date, stamps: [stamp])
            logRepository.updateLog(log)
        }
        dayList[index].log = logRepository.getLog(of: day.date)
    }

    func removeStamp(day: Day, index: Int) {
        if var log = day.log {
            log.stamps.remove(at: index)
            logRepository.updateLog(log)
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
        @Published var showStampPicker: Bool = false

        let shortWeekdays: [String]

        init(_ stampRepository: SR, _ logRepository: LR) {
            shortWeekdays = []
        }

        init() {
            let calendar = Calendar.current
            shortWeekdays = calendar.shortWeekdaySymbols
            let now = Date.now
            let day = Day(date: now,
                          isToday: true,
                          text: calendar.dayText(of: now),
                          weekday: calendar.weekday(of: now))
            dayList.append(day)
            title = now.title
        }

        func setDayList() {}
        func reloadLog() {}
        func paging(with pageDirection: PageDirection) {}
        func putStamp(stamp: Stamp) {}
        func removeStamp(day: Day, index: Int) {}
    }
}
