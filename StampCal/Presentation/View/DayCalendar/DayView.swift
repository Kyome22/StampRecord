/*
 DayView.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/06.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct DayView: View {
    let shortWeekdays: [String]
    let day: Day

    var body: some View {
        VStack {
            Text(shortWeekdays[day.weekday])
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .foregroundColor(SCColor.weekday(day.weekday))
                .background(SCColor.cellHighlightWeek)
                .cornerRadius(8)
            VStack {
                Text(day.text)
                    .foregroundColor(SCColor.weekday(day.weekday, day.isToday))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(SCColor.highlight(day.isToday))
                Text("😃")
                    .font(.title)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(SCColor.cellBackground)
            .cornerRadius(8)
        }
        .padding(8)
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView(shortWeekdays: [], day: Day(text: "", weekday: 0))
    }
}
