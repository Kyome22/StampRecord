/*
 Stamp.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/08.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

struct Stamp: Identifiable {
    var emoji: Character
    var summary: String
    var id: Character { emoji }

    static let dummy: [Self] = [
        Stamp(emoji: "💪", summary: "筋トレ"),
        Stamp(emoji: "🍽️", summary: "皿洗い"),
        Stamp(emoji: "🎹", summary: "ピアノの練習"),
        Stamp(emoji: "🏃", summary: "運動"),
        Stamp(emoji: "🛠️", summary: "開発"),
        Stamp(emoji: "🛁", summary: "風呂洗い"),
        Stamp(emoji: "📝", summary: "英語の勉強")
    ]
}
