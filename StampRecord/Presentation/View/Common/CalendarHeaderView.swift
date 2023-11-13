/*
 CalendarHeaderView.swift
 StampRecord

 Created by Takuto Nakamura on 2023/09/08.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct CalendarHeaderView: View {
    @Binding var title: String
    @Binding var isDaySelected: Bool
    @Binding var showStampFilter: Bool
    @Binding var showStampPicker: Bool
    @Binding var stamps: [Stamp]
    let resetHandler: () -> Void
    let updateFilterHandler: (StampFilterState) -> Void
    let toggleFilterHandler: (Stamp) -> Void
    let selectStampHandler: (Stamp) throws -> Void

    var body: some View {
        VStack(spacing: 0) {
            HeaderHStack {
                HStack(spacing: 16) {
                    Button {
                        showStampFilter = true
                    } label: {
                        Image(.funnel)
                            .font(.title2)
                    }
                    .buttonStyle(.square)
                    .disabled(stamps.isEmpty)
                    .stampFilter(
                        isPresented: $showStampFilter,
                        stamps: $stamps,
                        updateFilterHandler: updateFilterHandler,
                        toggleFilterHandler: toggleFilterHandler
                    )
                    Button {
                        resetHandler()
                    } label: {
                        Image(systemName: "arrow.uturn.right")
                            .font(.title2)
                    }
                    .buttonStyle(.square)
                }
                Text(title)
                    .font(.body)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                Button {
                    showStampPicker = true
                } label: {
                    Image(.stamp)
                        .font(.title2)
                }
                .buttonStyle(.square)
                .accessibilityIdentifier("CalendarHeaderView_StampButton")
                .disabled(!isDaySelected)
                .stampPicker(
                    isPresented: $showStampPicker,
                    stamps: stamps,
                    selectStampHandler: selectStampHandler,
                    attachmentAnchor: .point(.bottom),
                    arrowEdge: .top
                )
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            Divider()
        }
        .background(Color.toolbarBackground)
    }
}

#Preview {
    CalendarHeaderView(title: .constant(""),
                       isDaySelected: .constant(true),
                       showStampFilter: .constant(true),
                       showStampPicker: .constant(false),
                       stamps: .constant([]),
                       resetHandler: {},
                       updateFilterHandler: { _ in },
                       toggleFilterHandler: { _ in },
                       selectStampHandler: { _ in })
}
