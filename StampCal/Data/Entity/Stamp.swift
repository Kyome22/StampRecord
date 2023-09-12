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
    // TODO: idを後で修正する
    var id: String { emoji }

    static let dummy: [Self] = [
        Stamp(emoji: "💪", summary: "筋トレ"),
        Stamp(emoji: "🍽️", summary: "皿洗い"),
        Stamp(emoji: "🎹", summary: "ピアノの練習"),
        Stamp(emoji: "🏃", summary: "運動"),
        Stamp(emoji: "🛠️", summary: "開発"),
        Stamp(emoji: "🛁", summary: "風呂洗い"),
        Stamp(emoji: "📝", summary: "英語の勉強"),
        Stamp(emoji: "🗣️", summary: "人と話す"),
        Stamp(emoji: "🍞", summary: "朝食"),
        Stamp(emoji: "🍱", summary: "昼食"),
        Stamp(emoji: "🍛", summary: "夕食"),
        Stamp(emoji: "🧘", summary: "瞑想"),
        Stamp(emoji: "🏆", summary: "優勝"),
        Stamp(emoji: "🧩", summary: "パズル"),
        Stamp(emoji: "🏊‍♀️", summary: "水泳"),
        Stamp(emoji: "🎸", summary: "ギターの練習")
    ]
}
