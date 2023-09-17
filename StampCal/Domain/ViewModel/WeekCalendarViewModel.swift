/*
 WeekCalendarViewModel.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/27.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

protocol WeekCalendarViewModel: ObservableObject {
    var title: String { get set }
    var weekList: [Week] { get set }
    var shortWeekdays: [String] { get }

    init()

    func paging(with pageDirection: PageDirection)
}

final class WeekCalendarViewModelImpl: WeekCalendarViewModel {
    @Published var title: String = ""
    @Published var weekList: [Week] = []

    let shortWeekdays: [String]
    private let calendar = Calendar.current

    init() {
        shortWeekdays = calendar.shortWeekdaySymbols
        let now = Date.now
        weekList.append(Week(title: now.title, days: getDays(of: now)))
        if let date = getPreviousWeek(of: now) {
            weekList.insert(Week(title: date.title, days: getDays(of: date)), at: 0)
        }
        if let date = getNextWeek(of: now) {
            weekList.append(Week(title: date.title, days: getDays(of: date)))
        }
        title = weekList[1].title
    }

    private func getPreviousWeek(of date: Date) -> Date? {
        if let endOfWeek = calendar.endOfWeek(for: date),
           let previousDate = calendar.date(byAdding: .day, value: -7, to: endOfWeek) {
            return previousDate
        }
        return nil
    }

    private func getNextWeek(of date: Date) -> Date? {
        if let endOfWeek = calendar.endOfWeek(for: date),
           let nextDate = calendar.date(byAdding: .day, value: 7, to: endOfWeek) {
            return nextDate
        }
        return nil
    }

    private func getDays(of targetDate: Date) -> [Day] {
        let now = Date.now
        var days = [Day]()
        if let daysInMonth = calendar.daysInMonth(for: targetDate),
           let startOfMonth = calendar.startOfMonth(for: targetDate) {
            let day = calendar.component(.day, from: targetDate)
            let weekday = calendar.component(.weekday, from: targetDate)
            days = (day - weekday ..< day + 7 - weekday).map { i in
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
            if let baseDate = weekList[pageDirection.baseIndex].days.first?.date,
               let date = getPreviousWeek(of: baseDate) {
                weekList.insert(Week(title: date.title, days: getDays(of: date)), at: 0)
                weekList.removeLast()
            }
        case .forward:
            if let baseDate = weekList[pageDirection.baseIndex].days.first?.date,
               let date = getNextWeek(of: baseDate) {
                weekList.append(Week(title: date.title, days: getDays(of: date)))
                weekList.removeFirst()
            }
        }
        title = weekList[1].title
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class WeekCalendarViewModelMock: WeekCalendarViewModel {
        @Published var title: String = ""
        @Published var weekList: [Week] = []
        let shortWeekdays: [String]

        init() {
            let calendar = Calendar.current
            shortWeekdays = calendar.shortWeekdaySymbols
            let now = Date.now
            if let startOfMonth = calendar.startOfMonth(for: now) {
                let days = (0 ..< 7).map { i in
                    let date = calendar.date(byAdding: .day, value: i, to: startOfMonth)
                    return Day(date: date,
                               inMonth: true,
                               isToday: calendar.isEqual(a: date, b: now),
                               text: calendar.dayText(of: date),
                               weekday: calendar.weekday(of: date))
                }
                let week = Week(title: now.title, days: days)
                weekList.append(week)
                title = now.title
            }
        }

        func paging(with pageDirection: PageDirection) {}
    }
}
