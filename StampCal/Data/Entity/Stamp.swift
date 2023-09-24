/*
 Stamp.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/08.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import UIKit
//import CoreImage.CIFilterBuiltins

struct Stamp: Identifiable, Equatable, CustomStringConvertible {
    var emoji: String
    var summary: String
    var createdDate: Date
    var id: String

    var description: String {
        return "emoji: \(emoji), summary: \(summary), createdDate: \(createdDate.timeIntervalSince1970)"
    }

    init(emoji: String, summary: String, createdDate: Date = .now) {
        self.emoji = emoji
        self.summary = summary
        self.createdDate = createdDate
        self.id = emoji.unicodeScalars
            .map { String(format: "%X", $0.value) }
            .joined(separator: "-")
    }

    // ボツ
    private func createStampImage() -> CGImage? {
        Swift.print("create stamp \(emoji)")
        let stampSize = CGSize(width: 320, height: 320)

        let textFilter = CIFilter.textImageGenerator()
        textFilter.text = emoji
        textFilter.fontSize = 150
        textFilter.scaleFactor = 1.0
        guard let output = textFilter.outputImage else { return nil }

        var textSize = output.extent.size
        var textAt = CGPoint(x: 0.5 * (stampSize.width - textSize.width),
                             y: 0.5 * (stampSize.height - textSize.height))
        let output2 = output.transformed(by: CGAffineTransform(translationX: textAt.x, y: textAt.y))

        let exposureFilter = CIFilter.exposureAdjust()
        exposureFilter.inputImage = output2
        exposureFilter.ev = -0.5
        guard let output3 = exposureFilter.outputImage else { return nil }

        let sourceOverFilter = CIFilter.sourceOverCompositing()
        sourceOverFilter.inputImage = output3
        sourceOverFilter.backgroundImage = CIImage(image: UIImage(named: "stamp.frame")!)
        guard let output4 = sourceOverFilter.outputImage else { return nil }

        let sourceOutFilter = CIFilter.sourceOutCompositing()
        sourceOutFilter.inputImage = output4
        sourceOutFilter.backgroundImage = CIImage(image: UIImage(named: "stamp.text.frame")!)
        guard let output5 = sourceOutFilter.outputImage else { return nil }

        textFilter.text = summary
        textFilter.fontSize = 30
        textFilter.scaleFactor = 1.0
        guard let output6 = textFilter.outputImage else { return nil }

        textSize = output6.extent.size
        let ratio: CGFloat = min(1.0, 200 / textSize.width)
        textAt = CGPoint(x: 0.5 * (stampSize.width - ratio * textSize.width), y: 52)

        let output7 = output6
            .transformed(by: CGAffineTransform(scaleX: ratio, y: 1))
            .transformed(by: CGAffineTransform(translationX: textAt.x, y: textAt.y))

        sourceOverFilter.inputImage = output7
        sourceOverFilter.backgroundImage = output5
        guard let output8 = sourceOverFilter.outputImage else { return nil }

        let invertFilter = CIFilter.colorInvert()
        invertFilter.inputImage = output8
        guard let output9 = invertFilter.outputImage else { return nil }

        let alphaFilter = CIFilter.maskToAlpha()
        alphaFilter.inputImage = output9
        guard let output10 = alphaFilter.outputImage else { return nil }

        return CIContext().createCGImage(output10, from: output10.extent)
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
