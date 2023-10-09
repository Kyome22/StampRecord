/*
 MDayView.swift
 StampCal

 Created by Takuto Nakamura on 2023/10/08.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct MDayView: View {
    @Binding var isSelected: Bool
    let isPhone: Bool
    let orientation: DeviceOrientation
    let day: Day
    let selectHandler: () -> Void
    let removeStampHandler: (Day, Int) -> Void

    var body: some View {
        VStack(spacing: 0) {
            Text(day.text)
                .frame(maxWidth: .infinity)
                .padding(.vertical, isPhone ? 2 : 4)
                .foregroundColor(Color.weekday(day.weekday, day.isToday))
                .background {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.highlight(day.isToday))
                }
                .padding(4)
            Divider()
                .overlay(Color(.cellBorder))
                .padding(.horizontal, 4)
            if let log = day.log {
                switch orientation {
                case .portrait:
                    OverlappingVStack(alignment: .top, spacing: 4) {
                        ForEach(log.stamps.indices, id: \.self) { index in
                            StampCardView(stamp: log.stamps[index]) {
                                removeStampHandler(day, index)
                            }
                        }
                    }
                    .padding(4)
                case .landscape:
                    OverlappingHStack(alignment: .leading, spacing: 4) {
                        ForEach(log.stamps.indices, id: \.self) { index in
                            StampCardView(stamp: log.stamps[index]) {
                                removeStampHandler(day, index)
                            }
                        }
                    }
                    .padding(4)
                }
            } else {
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(isSelected ? Color(.cellHighlight) : Color(.cellBackground))
        .cornerRadius(8)
        .onTapGesture {
            selectHandler()
        }
        .shadow(color: Color(.shadow), radius: 2, x: 0, y: 3)
    }
}

#Preview {
    MDayView(isSelected: .constant(false),
             isPhone: true,
             orientation: .portrait,
             day: Day(text: "", weekday: 0),
             selectHandler: {},
             removeStampHandler: { _, _ in })
}
