/*
 LoggedStamp.swift
 StampRecord

 Created by Takuto Nakamura on 2023/11/29.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

struct LoggedStamp: Identifiable, Equatable, CustomStringConvertible {
    var id = UUID()
    var stamp: Stamp
    var stampID: UUID { stamp.id }
    var emoji: String { stamp.emoji }
    var summary: String { stamp.summary }
    var isIncluded: Bool { stamp.isIncluded }
    var description: String { stamp.description }
}
