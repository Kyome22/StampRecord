/*
 StampFilterView.swift
 StampRecord

 Created by Takuto Nakamura on 2023/11/13.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct StampFilterView: View {
    @Binding var stamps: [Stamp]

    let updateFilterHandler: (StampFilterState) -> Void
    let toggleFilterHandler: (Stamp) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            let state = StampFilterState(stamps: stamps)
            HStack(spacing: 8) {
                Image(systemName: state.imageName)
                    .foregroundStyle(state.imageColor)
                Text(state.label)
                    .foregroundStyle(Color.secondary)
            }
            .onTapGesture {
                updateFilterHandler(state)
            }
            Divider()
            ForEach(stamps) { stamp in
                Toggle(isOn: Binding<Bool>(
                    get: { stamp.isIncluded },
                    set: { _ in toggleFilterHandler(stamp) }
                )) {
                    Text(verbatim: "\(stamp.emoji) \(stamp.summary)")
                }
                .toggleStyle(.checkmarkToggle)
            }
        }
        .font(.title3)
        .padding(8)
        .fixedSize()
        .background(Color.cellBackground)
    }
}

#Preview {
    StampFilterView(stamps: .constant([]),
                    updateFilterHandler: { _ in},
                    toggleFilterHandler: { _ in })
}
