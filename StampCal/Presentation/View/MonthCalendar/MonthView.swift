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
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                ForEach(0 ..< 7, id: \.self) { i in
                    Text(shortWeekdays[i])
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .foregroundColor(Color.weekday(i))
                        .background(Color(.cellHighlightWeek))
                        .cornerRadius(8)
                        .shadow(color: Color(.shadow), radius: 2, x: 0, y: 3)
                }
            }
            ForEach(days.chunked(by: 7)) { chunk in
                HStack(spacing: 8) {
                    ForEach(chunk.elements) { day in
                        VStack(spacing: 0) {
                            if day.inMonth {
                                Text(day.text)
                                    .foregroundColor(Color.weekday(day.weekday, day.isToday))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 4)
                                    .background(Color.highlight(day.isToday))
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
                        .background(Color(.cellBackground))
                        .cornerRadius(8)
                        .shadow(color: Color(.shadow), radius: 2, x: 0, y: 3)
                        .opacity(day.inMonth ? 1.0 : 0.3)
                    }
                }
            }
        }
        .padding(24)
    }
}

struct MonthView_Previews: PreviewProvider {
    static var previews: some View {
        MonthView(shortWeekdays: [], days: [])
    }
}
