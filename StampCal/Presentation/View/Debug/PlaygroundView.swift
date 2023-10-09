/*
 PlaygroundView.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/24.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI
import CoreImage.CIFilterBuiltins

struct PlaygroundView: View {
    var body: some View {
        VStack(spacing: 8) {
            compare(emoji: "🎹", summary: "ピアノ")
            compare(emoji: "💪", summary: "筋トレ")
            compare(emoji: "🏖️", summary: "バカンスへGoGoGo!!")
            compare(emoji: "🍽️", summary: "Dish-washing")
        }
    }

    func compare(emoji: String, summary: String) -> some View {
        HStack(spacing: 20) {
            createStampImage(emoji: emoji, summary: summary)
                .renderingMode(.template)
                .resizable()
                .frame(width: 160, height: 160)
                .foregroundColor(Color(.cellBlue))
            Image(systemName: "arrowshape.right.fill")
                .font(.largeTitle)
            StampView(emoji: emoji, summary: summary)
        }
    }

    func createStampImage(emoji: String, summary: String) -> Image {
        let dummy = Image(systemName: "questionmark.circle.fill")
        let stampSize = CGSize(width: 320, height: 320)

        let textFilter = CIFilter.textImageGenerator()
        textFilter.text = emoji
        textFilter.fontSize = 150
        textFilter.scaleFactor = 1.0
        guard let output = textFilter.outputImage else { return dummy }

        var textSize = output.extent.size
        var textAt = CGPoint(x: 0.5 * (stampSize.width - textSize.width),
                             y: 0.5 * (stampSize.height - textSize.height))
        let output2 = output.transformed(by: CGAffineTransform(translationX: textAt.x, y: textAt.y))

        let exposureFilter = CIFilter.exposureAdjust()
        exposureFilter.inputImage = output2
        exposureFilter.ev = -0.5
        guard let output3 = exposureFilter.outputImage else { return dummy }

        let sourceOverFilter = CIFilter.sourceOverCompositing()
        sourceOverFilter.inputImage = output3
        sourceOverFilter.backgroundImage = CIImage(image: UIImage(named: "stamp.frame")!)
        guard let output4 = sourceOverFilter.outputImage else { return dummy }

        let sourceOutFilter = CIFilter.sourceOutCompositing()
        sourceOutFilter.inputImage = output4
        sourceOutFilter.backgroundImage = CIImage(image: UIImage(named: "stamp.text.frame")!)
        guard let output5 = sourceOutFilter.outputImage else { return dummy }

        textFilter.text = summary
        textFilter.fontSize = 30
        textFilter.scaleFactor = 1.0
        guard let output6 = textFilter.outputImage else { return dummy }

        textSize = output6.extent.size
        let ratio: CGFloat = min(1.0, 200 / textSize.width)
        textAt = CGPoint(x: 0.5 * (stampSize.width - ratio * textSize.width), y: 52)

        let output7 = output6
            .transformed(by: CGAffineTransform(scaleX: ratio, y: 1))
            .transformed(by: CGAffineTransform(translationX: textAt.x, y: textAt.y))

        sourceOverFilter.inputImage = output7
        sourceOverFilter.backgroundImage = output5
        guard let output8 = sourceOverFilter.outputImage else { return dummy }

        let invertFilter = CIFilter.colorInvert()
        invertFilter.inputImage = output8
        guard let output9 = invertFilter.outputImage else { return dummy }

        let alphaFilter = CIFilter.maskToAlpha()
        alphaFilter.inputImage = output9
        guard let output10 = alphaFilter.outputImage else { return dummy }

        guard let cgImage = CIContext().createCGImage(output10, from: output10.extent) else { return dummy }
        return Image(cgImage, scale: 1.0, label: Text(emoji))
    }

    func convertToSilhouette(emoji: String, color: Color) -> Image {
        let text = NSString(string: emoji)
        let uiColor = UIColor(color)
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 100)
        ]
        let textSize = text.size(withAttributes: attributes)
        let renderer = UIGraphicsImageRenderer(size: textSize)
        let image = renderer.image { context in
            text.draw(at: .zero, withAttributes: attributes)
            uiColor.setFill()
            context.fill(context.format.bounds, blendMode: .sourceIn)
        }
        return Image(uiImage: image)
    }
}

#Preview {
    PlaygroundView()
}

struct WidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
