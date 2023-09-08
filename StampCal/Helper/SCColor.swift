/*
 SCColor.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/28.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

enum SCColor {
    static var accent: Color {
        return Color.accentColor
    }
    static let appBackground = Color("app.background")
    static let cellBackground = Color("cell.background")
    static let cellRed = Color("cell.red")
    static let cellBlue = Color("cell.blue")
    static let cellHighlightStrong = Color("cell.highlight.strong")
    static let cellHighlightWeek = Color("cell.highlight.week")

    static func weekday(_ index: Int, _ isToday: Bool = false) -> Color {
        if isToday { return Color.white }
        switch index {
        case 0: return SCColor.cellRed
        case 6: return SCColor.cellBlue
        default: return Color.primary
        }
    }

    static func highlight(_ isToday: Bool) -> Color {
        if isToday {
            return SCColor.cellHighlightStrong
        } else {
            return SCColor.cellHighlightWeek
        }
    }
}
