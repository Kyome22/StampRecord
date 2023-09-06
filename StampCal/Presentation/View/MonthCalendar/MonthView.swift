/*
 MonthView.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/06.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct MonthView: View {
    let shortWeekdays: [String]
    let days: [Day]

    var body: some View {
        VStack {
            HStack {
                ForEach(0 ..< 7, id: \.self) { i in
                    Text(shortWeekdays[i])
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(weekdayColor(i))
                        .background(SCColor.cellBackground)
                        .cornerRadius(8)
                }
            }
            ForEach(days.chunked(by: 7)) { chunk in
                HStack {
                    ForEach(chunk.elements) { day in
                        VStack {
                            if day.inMonth {
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
                                    .font(.title2)
                            } else {
                                EmptyView()
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .background(SCColor.cellBackground)
                        .cornerRadius(8)
                        .opacity(day.inMonth ? 1.0 : 0.3)
                    }
                }
            }
        }
        .padding(8)
    }
}

struct MonthView_Previews: PreviewProvider {
    static var previews: some View {
        MonthView(shortWeekdays: [], days: [])
    }
}
