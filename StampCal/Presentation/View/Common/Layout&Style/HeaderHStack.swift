/*
 HeaderHStack.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/13.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct HeaderHStack: Layout {
    private func maxHeight(subviews: Subviews) -> CGFloat {
        return subviews.map { $0.sizeThatFits(.unspecified).height }.max() ?? .zero
    }

    private func maxSizeOfBothEdges(subviews: Subviews) -> CGSize {
        if subviews.count < 2 { return .zero }
        let subviewSizes = subviews.map { $0.sizeThatFits(.unspecified) }
        guard let first = subviewSizes.first, let last = subviewSizes.last else { return .zero }
        return CGSize(width: max(first.width, last.width),
                      height: max(first.height, last.height))
    }

    private func spacing(subviews: Subviews) -> CGFloat {
        return subviews.indices.map { index in
            guard index < subviews.count - 1 else { return 0 }
            return subviews[index].spacing.distance(to: subviews[index + 1].spacing, along: .horizontal)
        }
        .first ?? .zero
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        return CGSize(width: proposal.replacingUnspecifiedDimensions().width,
                      height: maxHeight(subviews: subviews))
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        if subviews.count < 3 { return }

        let maxSize = maxSizeOfBothEdges(subviews: subviews)
        let spacing = spacing(subviews: subviews)

        subviews.indices.forEach { index in
            if index == 0 {
                subviews[index].place(at: CGPoint(x: bounds.minX, y: bounds.midY),
                                      anchor: .leading,
                                      proposal: ProposedViewSize(maxSize))
            } else if index == subviews.count - 1 {
                subviews[index].place(at: CGPoint(x: bounds.maxX, y: bounds.midY),
                                      anchor: .trailing,
                                      proposal: ProposedViewSize(maxSize))
            } else {
                let size = subviews[index].sizeThatFits(.unspecified)
                let width = bounds.width - 2 * (maxSize.width + spacing)
                subviews[index].place(at: CGPoint(x: bounds.midX, y: bounds.midY),
                                      anchor: .center,
                                      proposal: ProposedViewSize(width: width, height: size.height))
            }
        }
    }
}
