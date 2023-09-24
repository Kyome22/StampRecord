/*
 SCColor.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/28.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

enum SCColor {
    static let accent = Color("accent")
    static let toolbarBackground = Color("toolbar.background")
    static let appBackground = Color("app.background")
    static let cellBackground = Color("cell.background")
    static let cellBorder = Color("cell.border")
    static let cellRed = Color("cell.red")
    static let cellBlue = Color("cell.blue")
    static let cellHighlightStrong = Color("cell.highlight.strong")
    static let cellHighlightWeek = Color("cell.highlight.week")
    static let delete = Color("delete")
    static let stampBackground = Color("stamp.background")
    static let shadow = Color(white: 0, opacity: 0.2)

    static func weekday(_ index: Int, _ isToday: Bool = false) -> Color {
        if isToday { return SCColor.cellBackground }
        switch index {
        case 0: return SCColor.cellRed
        case 6: return SCColor.cellBlue
        default: return Color.primary
        }
    }

    static func highlight(_ isToday: Bool) -> Color {
        if isToday {
            return SCColor.accent
        } else {
            return Color.clear
        }
    }
}
