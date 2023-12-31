/*
 MonthView.swift
 StampRecord

 Created by Takuto Nakamura on 2023/09/06.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct MonthView: View {
    @Binding var selectedDayID: UUID?
    let device: Device
    let spacing: CGFloat
    let weekdays: [Weekday]
    let days: [Day]
    let removeStampHandler: (Day, LoggedStamp) throws -> Void

    init(
        selectedDayID: Binding<UUID?>,
        device: Device,
        weekdays: [Weekday],
        days: [Day],
        removeStampHandler: @escaping (Day, LoggedStamp) throws -> Void
    ) {
        _selectedDayID = selectedDayID
        self.device = device
        self.spacing = device.spacing
        self.weekdays = weekdays
        self.days = days
        self.removeStampHandler = removeStampHandler
    }

    var body: some View {
        VStack(spacing: spacing) {
            HStack(spacing: spacing) {
                ForEach(weekdays) { weekday in
                    Text(weekday.shortLabel)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .foregroundStyle(Color.weekday(weekday))
                        .background(Color.cellBackground)
                        .cornerRadius(8)
                        .shadow(color: Color.shadow, radius: 2, x: 0, y: 3)
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
                                device: device,
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
            .foregroundStyle(Color.cellBackground)
            .shadow(color: Color.shadow, radius: 2, x: 0, y: 3)
            .opacity(0.3)
    }
}

#Preview {
    MonthView(selectedDayID: .constant(nil),
              device: .default,
              weekdays: Weekday.allCasesFromSunday,
              days: [],
              removeStampHandler: { _, _ in })
}
