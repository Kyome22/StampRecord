/*
 MonthCalendarViewModel.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/27.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

final class MonthCalendarViewModel: ObservableObject {
    @Published var target: Date = .now

    let calendar = Calendar.current
    let columns = [GridItem](repeating: .init(.flexible()), count: 7)

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
           let startOfMonth = calendar.startOfMonth(for: target),
           let endOfMonth = calendar.endOfMonth(for: target) {
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

    func previousMonth() {
        if let startOfMonth = calendar.startOfMonth(for: target),
           let previous = calendar.date(byAdding: .month, value: -1, to: startOfMonth) {
            withAnimation(.linear) {
                target = previous
            }
        }
    }

    func nextMonth() {
        if let startOfMonth = calendar.startOfMonth(for: target),
           let next = calendar.date(byAdding: .month, value: 1, to: startOfMonth) {
            withAnimation(.linear) {
                target = next
            }
        }
    }
}
