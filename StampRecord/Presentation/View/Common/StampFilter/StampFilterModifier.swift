/*
 StampFilterModifier.swift
 StampRecord

 Created by Takuto Nakamura on 2023/11/13.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct StampFilterModifier: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var stamps: [Stamp]
    let updateFilterHandler: (StampFilterState) -> Void
    let toggleFilterHandler: (Stamp) -> Void
    let attachmentAnchor: PopoverAttachmentAnchor
    let arrowEdge: Edge

    func body(content: Content) -> some View {
        content.popover(
            isPresented: $isPresented,
            attachmentAnchor: attachmentAnchor,
            arrowEdge: arrowEdge
        ) {
            StampFilterView(
                stamps: $stamps,
                updateFilterHandler: updateFilterHandler,
                toggleFilterHandler: toggleFilterHandler
            )
            .presentationCompactAdaptation(.popover)
        }
    }
}

extension View {
    func stampFilter(
        isPresented: Binding<Bool>,
        stamps: Binding<[Stamp]>,
        updateFilterHandler: @escaping (StampFilterState) -> Void,
        toggleFilterHandler: @escaping (Stamp) -> Void,
        attachmentAnchor: PopoverAttachmentAnchor = .rect(.bounds),
        arrowEdge: Edge = .top
    ) -> some View {
        return modifier(StampFilterModifier(
            isPresented: isPresented,
            stamps: stamps,
            updateFilterHandler: updateFilterHandler,
            toggleFilterHandler: toggleFilterHandler,
            attachmentAnchor: attachmentAnchor,
            arrowEdge: arrowEdge
        ))
    }
}
