/*
 MonthCalendarViewModel.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/27.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

final class MonthCalendarViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var monthList: [Month] = []

    private let calendar = Calendar.current

    var weekdays: [String] {
        calendar.shortWeekdaySymbols
    }

    init() {
        let now = Date.now
        monthList.append(Month(title: getTitle(of: now), days: getDays(of: now)))
        if let date = getPreviousMonth(of: now) {
            monthList.insert(Month(title: getTitle(of: date), days: getDays(of: date)), at: 0)
        }
        if let date = getNextMonth(of: now) {
            monthList.append(Month(title: getTitle(of: date), days: getDays(of: date)))
        }
        title = monthList[1].title
    }

    private func getTitle(of date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MMM"
        return formatter.string(from: date)
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
            (1 - startOrdinal ..< daysInMonth + 7 - endOrdinal).forEach { i in
                let date = calendar.date(byAdding: .day, value: i, to: startOfMonth)
                let inMonth = (0 ..< daysInMonth).contains(i)
                let isToday = calendar.isEqual(a: date, b: now)
                let text = calendar.dayText(of: date)
                days.append(Day(date: date, inMonth: inMonth, isToday: isToday, text: text))
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
                monthList.insert(Month(title: getTitle(of: date), days: getDays(of: date)), at: 0)
                monthList.removeLast()
            }
        case .forward:
            let days = monthList[pageDirection.baseIndex].days
            if let baseDate = days.first(where: { $0.inMonth })?.date,
               let date = getNextMonth(of: baseDate) {
                monthList.append(Month(title: getTitle(of: date), days: getDays(of: date)))
                monthList.removeFirst()
            }
        }
        title = monthList[1].title
    }
}
