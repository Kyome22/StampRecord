/*
 MonthView.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/06.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct MonthView: View {
    @Binding var selectedDayID: UUID?
    let isPhone: Bool
    let orientation: DeviceOrientation
    let spacing: CGFloat
    let shortWeekdays: [String]
    let days: [Day]
    let removeStampHandler: (Day, Int) -> Void

    init(
        selectedDayID: Binding<UUID?>,
        isPhone: Bool,
        orientation: DeviceOrientation,
        shortWeekdays: [String],
        days: [Day],
        removeStampHandler: @escaping (Day, Int) -> Void
    ) {
        _selectedDayID = selectedDayID
        self.isPhone = isPhone
        self.spacing = isPhone ? 8 : 16
        self.orientation = orientation
        self.shortWeekdays = shortWeekdays
        self.days = days
        self.removeStampHandler = removeStampHandler
    }

    var body: some View {
        VStack(spacing: spacing) {
            HStack(spacing: spacing) {
                ForEach(shortWeekdays.indices, id: \.self) { index in
                    Text(shortWeekdays[index])
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .foregroundColor(Color.weekday(index))
                        .background(Color(.cellBackground))
                        .cornerRadius(8)
                        .shadow(color: Color(.shadow), radius: 2, x: 0, y: 3)
                }
            }
            ForEach(days.chunked(by: 7)) { chunk in
                HStack(spacing: spacing) {
                    ForEach(chunk.elements) { day in
                        if day.inMonth {
                            MDayView(
                                isSelected: Binding<Bool>(
                                    get: { selectedDayID == day.id },
                                    set: { _ in }
                                ),
                                isPhone: isPhone,
                                orientation: orientation,
                                day: day,
                                selectHandler: {
                                    selectedDayID = day.id
                                },
                                removeStampHandler: removeStampHandler
                            )
                        } else {
                            phantomDayView
                        }
                    }
                }
            }
        }
        .padding(spacing)
    }


    var phantomDayView: some View {
        RoundedRectangle(cornerRadius: 8)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundColor(Color(.cellBackground))
            .shadow(color: Color(.shadow), radius: 2, x: 0, y: 3)
            .opacity(0.3)
    }
}

#Preview {
    MonthView(selectedDayID: .constant(nil),
              isPhone: true,
              orientation: .portrait,
              shortWeekdays: [],
              days: [],
              removeStampHandler: { _, _ in })
}
