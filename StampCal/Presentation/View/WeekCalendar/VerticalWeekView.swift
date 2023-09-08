/*
 VerticalWeekView.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/08.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct VerticalWeekView: View {
    let shortWeekdays: [String]
    let days: [Day]

    var body: some View {
        HStack(spacing: 16) {
            ForEach(days) { day in
                VStack(spacing: 16) {
                    Text(shortWeekdays[day.weekday])
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .foregroundColor(SCColor.weekday(day.weekday))
                        .background(SCColor.cellHighlightWeek)
                        .cornerRadius(8)
                        .shadow(color: SCColor.shadow, radius: 2, x: 0, y: 3)
                    VStack {
                        Text(day.text)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 4)
                            .foregroundColor(SCColor.weekday(day.weekday, day.isToday))
                            .background(SCColor.highlight(day.isToday))
                        VStack(spacing: 0) {
                            Text("😃")
                                .font(.title)
                        }
                        .padding(.vertical, 4)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .background(SCColor.cellBackground)
                    .cornerRadius(8)
                    .shadow(color: SCColor.shadow, radius: 2, x: 0, y: 3)
                }
            }
        }
        .padding(24)
    }
}

struct VerticalWeekView_Previews: PreviewProvider {
    static var previews: some View {
        VerticalWeekView(shortWeekdays: [], days: [])
    }
}
