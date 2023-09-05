/*
 Week.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/04.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

struct Week: Hashable {
    var id = UUID()
    var days: [Day]

    static func == (lhs: Week, rhs: Week) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
