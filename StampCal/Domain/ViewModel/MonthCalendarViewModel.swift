/*
 MonthCalendarViewModel.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/27.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

protocol MonthCalendarViewModel: ObservableObject {
    var title: String { get set }
    var monthList: [Month] { get set }
    var shortWeekdays: [String] { get }

    init()

    func paging(with pageDirection: PageDirection)
}

final class MonthCalendarViewModelImpl: MonthCalendarViewModel {
    @Published var title: String = ""
    @Published var monthList: [Month] = []

    let shortWeekdays: [String]
    private let calendar = Calendar.current

    init() {
        shortWeekdays = calendar.shortWeekdaySymbols
        let now = Date.now
        monthList.append(Month(title: now.title, days: getDays(of: now)))
        if let date = getPreviousMonth(of: now) {
            monthList.insert(Month(title: date.title, days: getDays(of: date)), at: 0)
        }
        if let date = getNextMonth(of: now) {
            monthList.append(Month(title: date.title, days: getDays(of: date)))
        }
        title = monthList[1].title
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
        let now = Date.now
        var days = [Day]()
        if let daysInMonth = calendar.daysInMonth(for: targetDate),
           let startOfMonth = calendar.startOfMonth(for: targetDate),
           let endOfMonth = calendar.endOfMonth(for: targetDate) {
            let startOrdinal = calendar.component(.weekday, from: startOfMonth)
            let endOrdinal = calendar.component(.weekday, from: endOfMonth)
            days = (1 - startOrdinal ..< daysInMonth + 7 - endOrdinal).map { i in
                let date = calendar.date(byAdding: .day, value: i, to: startOfMonth)
                return Day(date: date,
                           inMonth: (0 ..< daysInMonth).contains(i),
                           isToday: calendar.isEqual(a: date, b: now),
                           text: calendar.dayText(of: date),
                           weekday: calendar.weekday(of: date))
            }
        }
        return days
    }

    func paging(with pageDirection: PageDirection) {
        switch pageDirection {
        case .backward:
            let days = monthList[pageDirection.baseIndex].days
            if let baseDate = days.first(where: { $0.inMonth })?.date,
               let date = getPreviousMonth(of: baseDate) {
                monthList.insert(Month(title: date.title, days: getDays(of: date)), at: 0)
                monthList.removeLast()
            }
        case .forward:
            let days = monthList[pageDirection.baseIndex].days
            if let baseDate = days.first(where: { $0.inMonth })?.date,
               let date = getNextMonth(of: baseDate) {
                monthList.append(Month(title: date.title, days: getDays(of: date)))
                monthList.removeFirst()
            }
        }
        title = monthList[1].title
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class MonthCalendarViewModelMock: MonthCalendarViewModel {
        @Published var title: String = ""
        @Published var monthList: [Month] = []
        let shortWeekdays: [String]

        init() {
            let calendar = Calendar.current
            shortWeekdays = calendar.shortWeekdaySymbols
            let now = Date.now
            if let startOfMonth = calendar.startOfMonth(for: now) {
                let days = (0 ..< 30).map { i in
                    let date = calendar.date(byAdding: .day, value: i, to: startOfMonth)
                    return Day(date: date,
                               inMonth: true,
                               isToday: calendar.isEqual(a: date, b: now),
                               text: calendar.dayText(of: date),
                               weekday: calendar.weekday(of: date))
                }
                let month = Month(title: now.title, days: days)
                monthList.append(month)
            }
            title = now.title
        }

        func paging(with pageDirection: PageDirection) {}
    }
}
