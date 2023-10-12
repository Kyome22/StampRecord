/*
 Calendar+Extensions.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/27.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

extension Calendar {
    func startOfMonth(for date: Date) -> Date? {
        let components = dateComponents([.month, .year], from: date)
        return self.date(from: components)
    }

    func endOfMonth(for date: Date) -> Date? {
        guard let startOfMonth = startOfMonth(for: date),
              let nextMonth = self.date(byAdding: .month, value: 1, to: startOfMonth) else {
            return nil
        }
        return self.date(byAdding: .day, value: -1, to: nextMonth)
    }

    func daysInMonth(for date: Date) -> Int? {
        return range(of: .day, in: .month, for: date)?.count
    }

    func daysBetween(from a: Date?, to b: Date?) -> Int {
        guard let a, let b, let day = dateComponents([.day], from: a, to: b).day else {
            return -1
        }
        return day
    }

    func startOfWeek(for date: Date, with weekStartsAt: WeekStartsAt) -> Date? {
        let weekday = component(.weekday, from: date)
        let offset: Int = (weekStartsAt.ref - weekday) % 7 - 6
        return self.date(byAdding: .day, value: offset, to: date)
    }

    func endOfWeek(for date: Date, with weekStartsAt: WeekStartsAt) -> Date? {
        let weekday = component(.weekday, from: date)
        let offset: Int = (weekStartsAt.ref - weekday) % 7
        return self.date(byAdding: .day, value: offset, to: date)
    }

    func isEqual(a: Date?, b: Date?) -> Bool {
        guard let a, let b else { return false }
        return isDate(a, inSameDayAs: b)
    }

    func dayText(of date: Date?) -> String {
        guard let date else { return "?" }
        return component(.day, from: date).description
    }

    func weekday(of date: Date?) -> Weekday {
        guard let date, let weekday = Weekday(rawValue: component(.weekday, from: date) - 1) else {
            return .sunday
        }
        return weekday
    }
}
