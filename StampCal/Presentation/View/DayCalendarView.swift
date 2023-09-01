/*
 DayCalendarView.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/27.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct DayCalendarView: View {
    let today: String

    init() {
        let now = Date.now
//        let components = Calendar.current.dateComponents([.year, .month, .day, .weekday], from: now)
        let calendar = Calendar.current
        let year = calendar.component(.year, from: now)
        let month = calendar.component(.month, from: now)
        let day = calendar.component(.day, from: now)
        let weekday = calendar.component(.weekday, from: now)
        today = "\(year)/\(month)/\(day) (\(weekday))"
    }

    var body: some View {
        Text(today)
            .padding()
            .background(SCColor.background)
    }
}

struct DayCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        DayCalendarView()
    }
}
