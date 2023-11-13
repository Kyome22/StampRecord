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

extension Stamp {
    static let dummy: [Self] = {
        let info: [(String, String)] = [
            ("💪", "筋トレ"),
            ("🍽️", "皿洗い"),
            ("🎹", "ピアノの練習"),
            ("🏃", "運動"),
            ("🛠️", "開発"),
            ("🛁", "風呂洗い"),
            ("📝", "英語の勉強"),
            ("🗣️", "人と話す"),
            ("🍞", "朝食"),
            ("🍱", "昼食"),
            ("🍛", "夕食"),
            ("🧘", "瞑想"),
            ("🏆", "優勝"),
            ("🧩", "パズル"),
            ("🏊‍♀️", "水泳"),
            ("🎸", "ギターの練習")
        ]
        var i: Int = 0
        return info.map { (emoji, summary) in
            let date = Calendar.current.date(byAdding: .day, value: i, to: Date.now)!
            i += 1
            return Stamp(emoji: emoji, summary: summary, createdDate: date)
        }
    }()
}
