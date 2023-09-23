/*
 Day.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/27.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

struct Day: Hashable, Identifiable {
    var id = UUID()
    var date: Date?
    var inMonth: Bool = false
    var isToday: Bool = false
    var text: String
    var weekday: Int
    var log: Log?

    static func == (lhs: Day, rhs: Day) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func updated(with log: Log?) -> Day {
        return Day(date: date,
                   inMonth: inMonth,
                   isToday: isToday,
                   text: text,
                   weekday: weekday,
                   log: log)
    }
}
