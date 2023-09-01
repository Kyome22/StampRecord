/*
 WeekCalendarViewModel.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/27.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

final class WeekCalendarViewModel: ObservableObject {
    @Published var target: Date = .now
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

    let calendar = Calendar.current

    var title: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MMM"
        return formatter.string(from: target)
    }

    var weekdays: [String] {
        calendar.shortWeekdaySymbols
    }

    var days: [Day] {
        let now = Date.now
        var days = [Day]()
        if let daysInMonth = calendar.daysInMonth(for: target),
           let startOfMonth = calendar.startOfMonth(for: target) {
            let day = calendar.component(.day, from: target)
            let weekday = calendar.component(.weekday, from: target)
            (day - weekday ..< day + 7 - weekday).forEach { i in
                let date = calendar.date(byAdding: .day, value: i, to: startOfMonth)
                let inMonth = (0 ..< daysInMonth).contains(i)
                let isToday = calendar.isEqual(a: date, b: now)
                days.append(Day(date: date, inMonth: inMonth, isToday: isToday))
            }
        }
        return days
    }

    func previousWeek() {
        if let endOfWeek = calendar.endOfWeek(for: target),
           let previous = calendar.date(byAdding: .day, value: -7, to: endOfWeek) {
            target = previous
        }
    }

    func nextWeek() {
        if let endOfWeek = calendar.endOfWeek(for: target),
           let next = calendar.date(byAdding: .day, value: 7, to: endOfWeek) {
            target = next
        }
    }

    func dayText(of date: Date?) -> String {
        guard let date else { return "?" }
        return calendar.component(.day, from: date).description
    }
}
