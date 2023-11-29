/*
 OverlappingVStack.swift
 StampRecord

 Created by Takuto Nakamura on 2023/10/08.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct OverlappingVStack: Layout {
    let alignment: VerticalAlignment
    let spacing: CGFloat

    init(alignment: VerticalAlignment = .center, spacing: CGFloat = 8) {
        self.alignment = alignment
        self.spacing = spacing
    }

    private func maxWidth(subviews: Subviews) -> CGFloat {
        return subviews.map { $0.sizeThatFits(.unspecified).width }.max() ?? .zero
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let dimensions = proposal.replacingUnspecifiedDimensions()
        return CGSize(width: min(maxWidth(subviews: subviews), dimensions.width),
                      height: dimensions.height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        if subviews.isEmpty { return }
        let mw = min(maxWidth(subviews: subviews), bounds.width)
        let idealHeight = mw * CGFloat(subviews.count) + spacing * CGFloat(subviews.count - 1)
        if bounds.height < idealHeight {
            let h = (bounds.height - mw) / CGFloat(subviews.count - 1)
            var point = CGPoint(x: bounds.midX, y: bounds.minY + 0.5 * mw)
            subviews.indices.forEach { index in
                subviews[index].place(at: point, 
                                      anchor: .center,
                                      proposal: ProposedViewSize(width: mw, height: mw))
                point.y += h
            }
        } else {
            let diff = bounds.height - idealHeight
            let offset: CGFloat
            switch alignment {
            case .top:    offset = 0
            case .center: offset = 0.5 * diff
            case .bottom: offset = diff
            default:      offset = 0.5 * diff
            }
            var point = CGPoint(x: bounds.midX, y: bounds.minY + offset)
            subviews.indices.forEach { index in
                subviews[index].place(at: point,
                                      anchor: .top,
                                      proposal: ProposedViewSize(width: mw, height: mw))
                point.y += mw
                if index < subviews.count - 1 {
                    point.y += spacing
                }
            }
        }
    }
}
