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
                    wrapText(maxKey: "MMM", key: shortWeekdays[day.weekday])
                        .frame(maxHeight: .infinity)
                        .padding(.horizontal, 4)
                        .foregroundColor(SCColor.weekday(day.weekday))
                        .background(SCColor.cellHighlightWeek)
                        .cornerRadius(8)
                    HStack {
                        wrapText(maxKey: "88", key: day.text)
                            .frame(maxHeight: .infinity)
                            .padding(.horizontal, 8)
                            .foregroundColor(SCColor.weekday(day.weekday, day.isToday))
                            .background(SCColor.highlight(day.isToday))
                        HStack(spacing: 0) {
                            Text("😃")
                                .font(.title)
                        }
                        .padding(.horizontal, 4)
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
