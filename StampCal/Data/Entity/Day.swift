/*
 Day.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/27.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

struct Day: Identifiable {
    var id = UUID()
    var date: Date?
    var inMonth: Bool
    var isToday: Bool
    var text: String
}
