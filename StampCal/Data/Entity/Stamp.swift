/*
 Stamp.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/08.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

struct Stamp: Identifiable {
    var emoji: String
    var summary: String
    var createdDate: Date
    var id: String

    init(emoji: String, summary: String, createdDate: Date = .now) {
        self.emoji = emoji
        self.summary = summary
        self.createdDate = createdDate
        self.id = emoji.unicodeScalars
            .map { String(format: "%X", $0.value) }
            .joined(separator: "-")
    }

    static let dummy: [Self] = [
        Stamp(emoji: "💪", summary: "筋トレ", createdDate: Date(timeIntervalSince1970: 1690815600.0)),
        Stamp(emoji: "🍽️", summary: "皿洗い", createdDate: Date(timeIntervalSince1970: 1690902000.0)),
        Stamp(emoji: "🎹", summary: "ピアノの練習", createdDate: Date(timeIntervalSince1970: 1690988400.0)),
        Stamp(emoji: "🏃", summary: "運動", createdDate: Date(timeIntervalSince1970: 1691074800.0)),
        Stamp(emoji: "🛠️", summary: "開発", createdDate: Date(timeIntervalSince1970: 1691161200.0)),
        Stamp(emoji: "🛁", summary: "風呂洗い", createdDate: Date(timeIntervalSince1970: 1691247600.0)),
        Stamp(emoji: "📝", summary: "英語の勉強", createdDate: Date(timeIntervalSince1970: 1691334000.0)),
        Stamp(emoji: "🗣️", summary: "人と話す", createdDate: Date(timeIntervalSince1970: 1691420400.0)),
        Stamp(emoji: "🍞", summary: "朝食", createdDate: Date(timeIntervalSince1970: 1691506800.0)),
        Stamp(emoji: "🍱", summary: "昼食", createdDate: Date(timeIntervalSince1970: 1691593200.0)),
        Stamp(emoji: "🍛", summary: "夕食", createdDate: Date(timeIntervalSince1970: 1691679600.0)),
        Stamp(emoji: "🧘", summary: "瞑想", createdDate: Date(timeIntervalSince1970: 1691766000.0)),
        Stamp(emoji: "🏆", summary: "優勝", createdDate: Date(timeIntervalSince1970: 1691852400.0)),
        Stamp(emoji: "🧩", summary: "パズル", createdDate: Date(timeIntervalSince1970: 1691938800.0)),
        Stamp(emoji: "🏊‍♀️", summary: "水泳", createdDate: Date(timeIntervalSince1970: 1692025200.0)),
        Stamp(emoji: "🎸", summary: "ギターの練習", createdDate: Date(timeIntervalSince1970: 1692111600.0))
    ]
}
