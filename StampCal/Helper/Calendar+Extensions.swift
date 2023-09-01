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

    func startOfWeek(for date: Date) -> Date? {
        let weekday = component(.weekday, from: date)
        return self.date(byAdding: .day, value: 1 - weekday, to: date)
    }

    func endOfWeek(for date: Date) -> Date? {
        let weekday = component(.weekday, from: date)
        return self.date(byAdding: .day, value: 7 - weekday, to: date)
    }

    func isEqual(a: Date?, b: Date) -> Bool {
        guard let a else { return false }
        return self.isDate(a, inSameDayAs: b)
    }
}
