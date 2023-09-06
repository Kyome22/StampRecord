/*
 WeekView.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/04.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct WeekView: View {
    let shortWeekdays: [String]
    let days: [Day]

    var body: some View {
        VStack {
            ForEach(days) { day in
                HStack {
                    Text(shortWeekdays[day.weekday])
                        .frame(width: 64)
                        .frame(maxHeight: .infinity)
                        .foregroundColor(weekdayColor(day.weekday))
                        .background(SCColor.cellBackground)
                        .cornerRadius(8)
                    HStack {
                        wrapText(maxKey: "AA", key: day.text)
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
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .background(SCColor.cellBackground)
                    .cornerRadius(8)
                }
            }
        }
        .padding(8)
    }
}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        WeekView(shortWeekdays: [], days: [])
    }
}
