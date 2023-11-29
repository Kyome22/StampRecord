/*
 FlexibleHStack.swift
 StampRecord

 Created by Takuto Nakamura on 2023/11/28.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct FlexibleHStack: Layout {
    let spacing: CGFloat

    init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        return proposal.replacingUnspecifiedDimensions()
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let aspectRatio = bounds.width / bounds.height
        let count = subviews.count

        let ratios = (0 ..< count).map { i in
            let top = CGFloat(count - i)
            let bottom = ceil(CGFloat(count) / top)
            return top / bottom
        }

        let index = ratios.map { abs(aspectRatio - $0) }
            .enumerated()
            .min { $0.element < $1.element }?
            .offset ?? 0
        let columnsCount: Int = (count - index)
        let hCount = CGFloat(columnsCount)
        let vCount = ceil(CGFloat(count) / CGFloat(columnsCount))

        let width = (bounds.width - (hCount - 1) * spacing) / hCount
        let height = (bounds.height - (vCount - 1) * spacing) / vCount

        subviews.indices.forEach { index in
            let x = bounds.minX + CGFloat(index % columnsCount) * (width + spacing)
            let y = bounds.minY + CGFloat(index / columnsCount) * (height + spacing)
            subviews[index].place(at: CGPoint(x: x, y: y),
                                  anchor: .topLeading,
                                  proposal: ProposedViewSize(width: width, height: height))
        }
    }
}
