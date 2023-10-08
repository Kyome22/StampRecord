/*
 OverlappingVStack.swift
 StampCal

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

    private func maxHeight(subviews: Subviews) -> CGFloat {
        return subviews.map { $0.sizeThatFits(.unspecified).height }.max() ?? .zero
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        return CGSize(width: maxWidth(subviews: subviews),
                      height: proposal.replacingUnspecifiedDimensions().height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        if subviews.isEmpty { return }
        let mw = maxWidth(subviews: subviews)
        let mh = maxHeight(subviews: subviews)
        let idealHeight = mh * CGFloat(subviews.count) + spacing * CGFloat(subviews.count - 1)
        if bounds.height < idealHeight {
            let h = (bounds.height - mh) / CGFloat(subviews.count - 1)
            var point = CGPoint(x: bounds.midX, y: bounds.minY + 0.5 * mh)
            subviews.indices.forEach { index in
                subviews[index].place(at: point, 
                                      anchor: .center,
                                      proposal: ProposedViewSize(width: mw, height: mh))
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
                                      proposal: ProposedViewSize(width: mw, height: mh))
                point.y += mh
                if index < subviews.count - 1 {
                    point.y += spacing
                }
            }
        }
    }
}
