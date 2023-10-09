/*
 VerticalWeekView.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/08.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct VerticalWeekView: View {
    @Binding var selectedDayID: UUID?
    let shortWeekdays: [String]
    let days: [Day]
    let removeStampHandler: (Day, Int) -> Void

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
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
            HStack(spacing: 16) {
                ForEach(days) { day in
                    VWDayView(
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
    VerticalWeekView(selectedDayID: .constant(nil),
                     shortWeekdays: [],
                     days: [],
                     removeStampHandler: { _, _ in })
}
