/*
 CalendarHeaderView.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/08.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct CalendarHeaderView: View {
    @Binding var title: String
    @Binding var daySelected: Bool
    @Binding var showStampPicker: Bool
    let resetHandler: () -> Void
    let selectStampHandler: (Stamp) -> Void

    var body: some View {
        VStack(spacing: 0) {
            HeaderHStack {
                Button {
                    resetHandler()
                } label: {
                    Text(Image(systemName: "arrow.uturn.right"))
                        .font(.title2)
                }
                .buttonStyle(.square)
                Text(verbatim: title)
                    .font(.body)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                Button {
                    showStampPicker = true
                } label: {
                    Text(Image(.stamp))
                        .font(.title2)
                }
                .buttonStyle(.square)
                .disabled(!daySelected)
                .stampPicker(
                    isPresented: $showStampPicker,
                    stamps: Stamp.dummy,
                    selectStampHandler: { stamp in
                        selectStampHandler(stamp)
                    },
                    attachmentAnchor: .point(.bottom),
                    arrowEdge: .top
                )
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            Divider()
        }
        .background(Color(.toolbarBackground))
    }
}

struct CalendarHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarHeaderView(title: .constant(""),
                           daySelected: .constant(true),
                           showStampPicker: .constant(false),
                           resetHandler: {},
                           selectStampHandler: { _ in })
    }
}
