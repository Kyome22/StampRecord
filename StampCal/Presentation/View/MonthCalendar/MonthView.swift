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
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .foregroundColor(SCColor.weekday(i))
                        .background(SCColor.cellHighlightWeek)
                        .cornerRadius(8)
                }
            }
            ForEach(days.chunked(by: 7)) { chunk in
                HStack {
                    ForEach(chunk.elements) { day in
                        VStack(spacing: 0) {
                            if day.inMonth {
                                Text(day.text)
                                    .foregroundColor(SCColor.weekday(day.weekday, day.isToday))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 4)
                                    .background(SCColor.highlight(day.isToday))
                                VStack {
                                    Text("😃")
                                        .font(.title2)
                                }
                                .padding(.vertical, 4)
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
