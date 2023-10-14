/*
 HWDayView.swift
StampRecord

 Created by Takuto Nakamura on 2023/09/25.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct HWDayView: View {
    @Binding var isSelected: Bool
    let day: Day
    let selectHandler: () -> Void
    let removeStampHandler: (Day, Int) -> Void

    var body: some View {
        HStack(spacing: 0) {
            wrapText(maxKey: "88", key: day.text)
                .frame(maxHeight: .infinity)
                .padding(.horizontal, 4)
                .foregroundColor(Color.weekday(day.weekday, day.isToday))
                .background {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.highlight(day.isToday))
                }
                .padding(4)
            Divider()
                .overlay(Color.cellBorder)
                .padding(.vertical, 4)
            if let log = day.log {
                HStackedStamps(stamps: log.stamps) { index in
                    removeStampHandler(day, index)
                }
            } else {
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(isSelected ? Color.cellHighlight : Color.cellBackground)
        .cornerRadius(8)
        .onTapGesture {
            selectHandler()
        }
        .shadow(color: Color.shadow, radius: 2, x: 0, y: 3)
    }
}

#Preview {
    HWDayView(isSelected: .constant(false),
              day: Day(text: "", weekday: .sunday),
              selectHandler: {},
              removeStampHandler: { _, _ in })
}
