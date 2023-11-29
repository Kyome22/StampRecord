/*
 OverlappingHStack.swift
 StampRecord

 Created by Takuto Nakamura on 2023/09/26.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct OverlappingHStack: Layout {
    let alignment: HorizontalAlignment
    let spacing: CGFloat

    init(alignment: HorizontalAlignment = .center, spacing: CGFloat = 8) {
        self.alignment = alignment
        self.spacing = spacing
    }

    private func maxHeight(subviews: Subviews) -> CGFloat {
        return subviews.map { $0.sizeThatFits(.unspecified).height }.max() ?? .zero
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let dimensions = proposal.replacingUnspecifiedDimensions()
        return CGSize(width: dimensions.width,
                      height: min(maxHeight(subviews: subviews), dimensions.height))
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        if subviews.isEmpty { return }
        let mh = min(maxHeight(subviews: subviews), bounds.height)
        let idealWidth = mh * CGFloat(subviews.count) + spacing * CGFloat(subviews.count - 1)
        if bounds.width < idealWidth {
            let w = (bounds.width - mh) / CGFloat(subviews.count - 1)
            var point = CGPoint(x: bounds.minX + 0.5 * mh, y: bounds.midY)
            subviews.indices.forEach { index in
                subviews[index].place(at: point,
                                      anchor: .center,
                                      proposal: ProposedViewSize(width: mh, height: mh))
                point.x += w
            }
        } else {
            let diff = bounds.width - idealWidth
            let offset: CGFloat
            switch alignment {
            case .leading:  offset = 0
            case .center:   offset = 0.5 * diff
            case .trailing: offset = diff
            default:        offset = 0.5 * diff
            }
            var point = CGPoint(x: bounds.minX + offset, y: bounds.midY)
            subviews.indices.forEach { index in
                subviews[index].place(at: point,
                                      anchor: .leading,
                                      proposal: ProposedViewSize(width: mh, height: mh))
                point.x += mh
                if index < subviews.count - 1 {
                    point.x += spacing
                }
            }
        }
    }
}
