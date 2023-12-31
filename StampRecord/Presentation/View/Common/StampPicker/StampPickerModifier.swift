/*
 StampPickerModifier.swift
 StampRecord

 Created by Takuto Nakamura on 2023/09/23.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct StampPickerModifier: ViewModifier {
    @Binding var isPresented: Bool
    let stamps: [Stamp]
    let selectStampHandler: (Stamp) throws -> Void
    let attachmentAnchor: PopoverAttachmentAnchor
    let arrowEdge: Edge

    func body(content: Content) -> some View {
        content.popover(
            isPresented: $isPresented,
            attachmentAnchor: attachmentAnchor,
            arrowEdge: arrowEdge
        ) {
            StampPickerView(
                stamps: stamps,
                selectStampHandler: selectStampHandler
            )
            .presentationCompactAdaptation(.popover)
        }
    }
}

extension View {
    func stampPicker(
        isPresented: Binding<Bool>,
        stamps: [Stamp],
        selectStampHandler: @escaping (Stamp) throws -> Void,
        attachmentAnchor: PopoverAttachmentAnchor = .rect(.bounds),
        arrowEdge: Edge = .top
    ) -> some View {
        return modifier(StampPickerModifier(
            isPresented: isPresented,
            stamps: stamps,
            selectStampHandler: selectStampHandler,
            attachmentAnchor: attachmentAnchor,
            arrowEdge: arrowEdge
        ))
    }
}
