/*
 Month.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/06.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

struct Month: Hashable {
    var id = UUID()
    var title: String
    var days: [Day]

    static func == (lhs: Month, rhs: Month) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
