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
        HStack(spacing: 16) {
            ForEach(days) { day in
                VWDayView(
                    isSelected: Binding<Bool>(
                        get: { selectedDayID == day.id },
                        set: { _ in }
                    ),
                    shortWeekday: shortWeekdays[day.weekday],
                    day: day,
                    selectHandler: {
                        selectedDayID = day.id
                    },
                    removeStampHandler: removeStampHandler
                )
            }
        }
        .padding(16)
    }
}

struct VerticalWeekView_Previews: PreviewProvider {
    static var previews: some View {
        VerticalWeekView(selectedDayID: .constant(nil),
                         shortWeekdays: [],
                         days: [],
                         removeStampHandler: { _, _ in })
    }
}
