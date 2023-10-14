/*
 Week.swift
StampRecord

 Created by Takuto Nakamura on 2023/09/04.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

struct Week: Hashable, Identifiable {
    var id = UUID()
    var title: String
    var days: [Day]

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
