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
                .frame(height: 40)
                .frame(maxWidth: .infinity)
                .foregroundColor(weekdayColor(day.weekday))
                .background(SCColor.cellBackground)
                .cornerRadius(8)
            VStack {
                Text(day.text)
                    .foregroundColor(weekdayColor(day.weekday, day.isToday))
                    .padding(2)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(day.isToday ? SCColor.accent : Color.clear)
                            .aspectRatio(1, contentMode: .fill)
                    )
                    .padding(6)
                Text("😃")
                    .font(.title)
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
