/*
 Day.swift
 StampRecord

 Created by Takuto Nakamura on 2023/08/27.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation
import InfinitePaging

struct Day: Pageable {
    var id = UUID()
    var date: Date?
    var inMonth: Bool = false
    var isToday: Bool = false
    var text: String
    var weekday: Weekday
    var log: Log?
}
