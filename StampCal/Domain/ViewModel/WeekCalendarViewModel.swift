/*
 WeekCalendarViewModel.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/27.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

final class WeekCalendarViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var weekList: [Week] = [] {
        didSet {
            title = updateTitle()
        }
    }
    @Published var isPortrait: Bool = true
    @Published var orientation: UIDeviceOrientation = .unknown {
        didSet {
            if orientation.isPortrait {
                self.isPortrait = true
            } else if orientation.isLandscape {
                self.isPortrait = false
            }
        }
    }

    private let calendar = Calendar.current

    var weekdays: [String] {
        calendar.shortWeekdaySymbols
    }

    init() {
        let now = Date.now
        weekList.append(Week(days: getDays(of: now)))
        if let previousWeek = getPreviousWeek(of: now) {
            weekList.insert(Week(days: getDays(of: previousWeek)), at: 0)
        }
        if let nextWeek = getNextWeek(of: now) {
            weekList.append(Week(days: getDays(of: nextWeek)))
        }
    }

    private func updateTitle() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MMM"
        if 1 < weekList.count,
           let date = weekList[1].days.first?.date {
            return formatter.string(from: date)
        }
        return formatter.dateFormat
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
            (day - weekday ..< day + 7 - weekday).forEach { i in
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
            if let baseDate = weekList[pageDirection.baseIndex].days.first?.date,
               let previousWeek = getPreviousWeek(of: baseDate) {
                weekList.insert(Week(days: getDays(of: previousWeek)), at: 0)
                weekList.removeLast()
            }
        case .forward:
            if let baseDate = weekList[pageDirection.baseIndex].days.first?.date,
               let nextWeek = getNextWeek(of: baseDate) {
                weekList.append(Week(days: getDays(of: nextWeek)))
                weekList.removeFirst()
            }
        }
    }
}
