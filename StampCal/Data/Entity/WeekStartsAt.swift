/*
 WeekStartsAt.swift
 StampCal

 Created by Takuto Nakamura on 2023/10/12.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

enum WeekStartsAt: Int, CaseIterable, Identifiable {
    case sunday
    case monday

    var id: Int { rawValue }

    var label: LocalizedStringKey {
        switch self {
        case .sunday: return "sunday"
        case .monday: return "monday"
        }
    }
}
