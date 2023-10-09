/*
 HorizontalWeekView.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/04.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct HorizontalWeekView: View {
    @Binding var selectedDayID: UUID?
    let shortWeekdays: [String]
    let days: [Day]
    let removeStampHandler: (Day, Int) -> Void

    var body: some View {
        HStack(spacing: 16) {
            VStack(spacing: 16) {
                ForEach(shortWeekdays.indices, id: \.self) { index in
                    wrapText(maxKey: "MMM", key: shortWeekdays[index])
                        .frame(maxHeight: .infinity)
                        .padding(.horizontal, 4)
                        .foregroundColor(Color.weekday(index))
                        .background(Color(.cellBackground))
                        .cornerRadius(8)
                        .shadow(color: Color(.shadow), radius: 2, x: 0, y: 3)
                }
            }
            VStack(spacing: 16) {
                ForEach(days) { day in
                    HWDayView(
                        isSelected: Binding<Bool>(
                            get: { selectedDayID == day.id },
                            set: { _ in }
                        ),
                        day: day,
                        selectHandler: {
                            selectedDayID = day.id
                        },
                        removeStampHandler: removeStampHandler
                    )
                }
            }
        }
        .padding(16)
    }
}

#Preview {
    HorizontalWeekView(selectedDayID: .constant(nil),
                       shortWeekdays: [],
                       days: [],
                       removeStampHandler: { _, _ in })
}
