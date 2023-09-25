/*
 HorizontalWeekView.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/04.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct HorizontalWeekView: View {
    let shortWeekdays: [String]
    let days: [Day]
    let putStampHandler: (Day, Stamp) -> Void
    let removeStampHandler: (Day, Int) -> Void

    var body: some View {
        VStack(spacing: 16) {
            ForEach(days) { day in
                HWDayView(
                    shortWeekday: shortWeekdays[day.weekday],
                    day: day,
                    putStampHandler: putStampHandler,
                    removeStampHandler: removeStampHandler
                )
            }
        }
        .padding(24)
    }
}

struct HorizontalWeekView_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalWeekView(shortWeekdays: [],
                           days: [],
                           putStampHandler: { _, _ in },
                           removeStampHandler: { _, _ in })
    }
}
