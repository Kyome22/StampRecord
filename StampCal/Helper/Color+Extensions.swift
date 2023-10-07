/*
 Color+Extensions.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/28.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

extension Color {
    static func weekday(_ index: Int, _ isToday: Bool = false) -> Color {
        if isToday { return Color(.cellBackground) }
        switch index {
        case 0: return Color(.cellRed)
        case 6: return Color(.cellBlue)
        default: return Color.primary
        }
    }

    static func highlight(_ isToday: Bool) -> Color {
        if isToday {
            return Color(.appAccent)
        } else {
            return Color.clear
        }
    }
}
