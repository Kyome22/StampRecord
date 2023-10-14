/*
 Tab.swift
StampRecord

 Created by Takuto Nakamura on 2023/09/18.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

enum Tab: String, Identifiable {
    case stamps
    case dayCalendar
    case weekCalendar
    case monthCalendar
    case settings

    var id: String { rawValue }
}
