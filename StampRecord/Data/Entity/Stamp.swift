/*
 Stamp.swift
 StampRecord

 Created by Takuto Nakamura on 2023/10/11.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

struct Stamp: Identifiable, Equatable, CustomStringConvertible {
    var id: UUID
    var emoji: String
    var summary: String
    var createdDate: Date
    var isIncluded: Bool

    var description: String {
        return "emoji: \(emoji), summary: \(summary), createdDate: \(createdDate.timeIntervalSince1970)"
    }

    init(id: UUID = UUID(), emoji: String, summary: String, createdDate: Date = .now) {
        self.id = id
        self.emoji = emoji
        self.summary = summary
        self.createdDate = createdDate
        self.isIncluded = true
    }
}
