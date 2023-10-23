/*
 Weekday.swift
 StampRecord

 Created by Takuto Nakamura on 2023/10/12.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

enum Weekday: Int, Identifiable, CaseIterable {
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday

    var id: Int { rawValue }

    var shortLabel: String {
        return Calendar.current.shortWeekdaySymbols[rawValue]
    }

    static var allCasesFromSunday: [Weekday] {
        return Self.allCases
    }

    static var allCasesFromMonday: [Weekday] {
        var array = Self.allCases
        array.append(array.removeFirst())
        return array
    }
}
