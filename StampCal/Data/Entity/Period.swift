/*
 Period.swift
 StampCal

 Created by Takuto Nakamura on 2023/10/13.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

enum Period: Int, Identifiable, CaseIterable {
    case day
    case week
    case month

    var id: Int { rawValue }

    var label: LocalizedStringKey {
        return LocalizedStringKey(String(describing: self))
    }

    var tab: Tab {
        switch self {
        case .day:   return .dayCalendar
        case .week:  return .weekCalendar
        case .month: return .monthCalendar
        }
    }
}
