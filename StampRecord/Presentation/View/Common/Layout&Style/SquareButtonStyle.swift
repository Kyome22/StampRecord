/*
 SquareButtonStyle.swift
StampRecord

 Created by Takuto Nakamura on 2023/09/14.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct SquareButtonContainer: Layout {
    private func maxLength(subviews: Subviews) -> CGFloat {
        return subviews.map { subview -> CGFloat in
            let size = subview.sizeThatFits(.unspecified)
            return max(size.width, size.height)
        }
        .max() ?? .zero
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let length = maxLength(subviews: subviews)
        return CGSize(width: length, height: length)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard subviews.count == 1 else { return }

        subviews.forEach { subview in
            subview.place(at: CGPoint(x: bounds.midX, y: bounds.midY),
                          anchor: .center,
                          proposal: proposal)
        }
    }
}

struct SquareButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        SquareButtonContainer {
            configuration.label
                .fixedSize()
                .foregroundColor(.accentColor)
                .opacity(configuration.isPressed ? 0.3 : 1.0)
        }
    }
}

extension ButtonStyle where Self == SquareButtonStyle {
    static var square: SquareButtonStyle {
        return SquareButtonStyle()
    }
}
