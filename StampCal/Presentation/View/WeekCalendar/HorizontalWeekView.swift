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
        VStack(spacing: 16) {
            ForEach(days) { day in
                HWDayView(
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

struct HorizontalWeekView_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalWeekView(selectedDayID: .constant(nil),
                           shortWeekdays: [],
                           days: [],
                           removeStampHandler: { _, _ in })
    }
}
