/*
 OverlappingHStack.swift
 StampCal

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

    private func maxWidth(subviews: Subviews) -> CGFloat {
        return subviews.map { $0.sizeThatFits(.unspecified).width }.max() ?? .zero
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        return CGSize(width: proposal.replacingUnspecifiedDimensions().width,
                      height: maxHeight(subviews: subviews))
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        if subviews.isEmpty { return }
        let mh = maxHeight(subviews: subviews)
        let mw = maxWidth(subviews: subviews)
        let idealWidth = mw * CGFloat(subviews.count) + spacing * CGFloat(subviews.count - 1)
        if bounds.width < idealWidth {
            let w = (bounds.width - mw) / CGFloat(subviews.count - 1)
            var point = CGPoint(x: bounds.minX + 0.5 * mw, y: bounds.midY)
            subviews.indices.forEach { index in
                subviews[index].place(at: point,
                                      anchor: .center,
                                      proposal: ProposedViewSize(width: mw, height: mh))
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
                                      proposal: ProposedViewSize(width: mw, height: mh))
                point.x += mw
                if index < subviews.count - 1 {
                    point.x += spacing
                }
            }
        }
    }
}
