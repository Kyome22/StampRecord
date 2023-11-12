/*
 MonthCalendarViewModel.swift
 StampRecord

 Created by Takuto Nakamura on 2023/08/27.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI
import Combine
import InfinitePaging

protocol MonthCalendarViewModel: ObservableObject {
    associatedtype SR: StampRepository
    associatedtype LR: LogRepository

    var title: String { get set }
    var monthList: [Month] { get set }
    var selectedDayID: UUID? { get set }
    var showStampPicker: Bool { get set }
    var stamps: [Stamp] { get set }
    var weekStartsAt: WeekStartsAt { get set }

    init(_ stampRepository: SR, _ logRepository: LR)

    func setMonthList()
    func setToday()
    func paging(with pageDirection: PageDirection)
    func putStamp(stamp: Stamp) throws
    func removeStamp(day: Day, index: Int) throws
}

final class MonthCalendarViewModelImpl<SR: StampRepository,
                                       LR: LogRepository>: MonthCalendarViewModel {
    typealias SR = SR
    typealias LR = LR

    @Published var title: String = ""
    @Published var monthList: [Month] = []
    @Published var selectedDayID: UUID? = nil
    @Published var showStampPicker: Bool = false
    @Published var stamps: [Stamp] = []
    @AppStorage(.weekStartsAt) var weekStartsAt: WeekStartsAt = .sunday

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

        setMonthList()
    }

    private func loadLog() {
        monthList.indices.forEach { i in
            monthList[i].days.indices.forEach { j in
                let date = monthList[i].days[j].date
                monthList[i].days[j].log = logRepository.getLog(of: date)
            }
        }
    }

    private func getPreviousMonth(of date: Date) -> Date? {
        if let startOfMonth = calendar.startOfMonth(for: date),
           let previousDate = calendar.date(byAdding: .month, value: -1, to: startOfMonth) {
            return previousDate
        }
        return nil
    }

    private func getNextMonth(of date: Date) -> Date? {
        if let startOfMonth = calendar.startOfMonth(for: date),
           let nextDate = calendar.date(byAdding: .month, value: 1, to: startOfMonth) {
            return nextDate
        }
        return nil
    }

    private func getDays(of targetDate: Date) -> [Day] {
        var days = [Day]()
        if let daysInMonth = calendar.daysInMonth(for: targetDate),
           let startOfMonth = calendar.startOfMonth(for: targetDate),
           let endOfMonth = calendar.endOfMonth(for: targetDate),
           let startOfWeek = calendar.startOfWeek(for: startOfMonth, with: weekStartsAt),
           let endOfWeek = calendar.endOfWeek(for: endOfMonth, with: weekStartsAt) {
            let total = calendar.daysBetween(from: startOfWeek, to: endOfWeek)
            days = (0 ... total).map { i in
                let date = calendar.date(byAdding: .day, value: i, to: startOfWeek)
                let diff = calendar.daysBetween(from: startOfMonth, to: date)
                return Day(date: date,
                           inMonth: (0 ..< daysInMonth).contains(diff),
                           isToday: calendar.isEqual(a: date, b: today),
                           text: calendar.dayText(of: date),
                           weekday: calendar.weekday(of: date),
                           log: logRepository.getLog(of: date))
            }
        }
        return days
    }

    func setMonthList() {
        today = Date.now
        monthList.removeAll()
        monthList.append(Month(title: today.title, days: getDays(of: today)))
        if let date = getPreviousMonth(of: today) {
            monthList.insert(Month(title: date.title, days: getDays(of: date)), at: 0)
        }
        if let date = getNextMonth(of: today) {
            monthList.append(Month(title: date.title, days: getDays(of: date)))
        }
        title = monthList[1].title
        selectedDayID = nil
    }

    func setToday() {
        let old = today
        today = Date.now
        if calendar.isEqual(a: old, b: today) { return }
        monthList.indices.forEach { i in
            monthList[i].days.indices.forEach { j in
                let date = monthList[i].days[j].date
                monthList[i].days[j].isToday = calendar.isEqual(a: date, b: today)
            }
        }
    }

    func paging(with pageDirection: PageDirection) {
        switch pageDirection {
        case .backward:
            if let days = monthList.first?.days,
               let baseDate = days.first(where: { $0.inMonth })?.date,
               let date = getPreviousMonth(of: baseDate) {
                monthList.insert(Month(title: date.title, days: getDays(of: date)), at: 0)
                monthList.removeLast()
            }
        case .forward:
            if let days = monthList.last?.days,
               let baseDate = days.first(where: { $0.inMonth })?.date,
               let date = getNextMonth(of: baseDate) {
                monthList.append(Month(title: date.title, days: getDays(of: date)))
                monthList.removeFirst()
            }
        }
        title = monthList[1].title
        selectedDayID = nil
        setToday()
    }

    func putStamp(stamp: Stamp) throws {
        guard let i = monthList.firstIndex(where: { $0.days.contains { $0.id == selectedDayID } }),
              let j = monthList[i].days.firstIndex(where: { $0.id == selectedDayID }) else {
            return
        }
        let day = monthList[i].days[j]
        if var log = day.log {
            log.stamps.append(stamp)
            try logRepository.updateLog(log)
        } else if let date = day.date {
            let log = Log(date: date, stamps: [stamp])
            try logRepository.updateLog(log)
        }
        monthList[i].days[j].log = logRepository.getLog(of: day.date)
    }

    func removeStamp(day: Day, index: Int) throws {
        if var log = day.log {
            log.stamps.remove(at: index)
            try logRepository.updateLog(log)
        }
        if let i = monthList.firstIndex(where: { $0.days.contains(day) }),
           let j = monthList[i].days.firstIndex(of: day) {
            monthList[i].days[j].log = logRepository.getLog(of: day.date)
        }
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class MonthCalendarViewModelMock: MonthCalendarViewModel {
        typealias SR = StampRepositoryMock
        typealias LR = LogRepositoryMock

        @Published var title: String = ""
        @Published var monthList: [Month] = []
        @Published var selectedDayID: UUID? = nil
        @Published var showStampPicker: Bool = false
        @Published var stamps: [Stamp] = []
        @Published var weekStartsAt: WeekStartsAt = .sunday

        init(_ stampRepository: SR, _ logRepository: LR) {}
        init() {
            let calendar = Calendar.current
            let today = Date.now
            if let startOfMonth = calendar.startOfMonth(for: today) {
                let days = (0 ..< 30).map { i in
                    let date = calendar.date(byAdding: .day, value: i, to: startOfMonth)
                    return Day(date: date,
                               inMonth: true,
                               isToday: calendar.isEqual(a: date, b: today),
                               text: calendar.dayText(of: date),
                               weekday: calendar.weekday(of: date))
                }
                let month = Month(title: today.title, days: days)
                monthList.append(month)
            }
            title = today.title
        }

        func setMonthList() {}
        func setToday() {}
        func paging(with pageDirection: PageDirection) {}
        func putStamp(stamp: Stamp) throws {}
        func removeStamp(day: Day, index: Int) throws {}
    }
}
