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
        VStack(spacing: 24) {
            Text(shortWeekdays[day.weekday])
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .foregroundColor(SCColor.weekday(day.weekday))
                .background(SCColor.cellHighlightWeek)
                .cornerRadius(8)
                .shadow(color: SCColor.shadow, radius: 3, x: 0, y: 3)
            VStack(spacing: 0) {
                Text(day.text)
                    .foregroundColor(SCColor.weekday(day.weekday, day.isToday))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(SCColor.highlight(day.isToday))
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 8) {
                        if let log = day.log {
                            ForEach(log.stamps) { stamp in
                                HStack(alignment: .center, spacing: 16) {
                                    Text(stamp.emoji)
                                        .font(.largeTitle)
                                    Text(stamp.summary)
                                        .font(.body)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(8)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 100)
                                        .stroke(SCColor.cellBorder, lineWidth: 1)
                                }
                            }
                        } else {
                            EmptyView()
                        }
                    }
                    .padding(16)
                }
                Divider()
                HStack {
                    Spacer()
                    Button {

                    } label: {
                        Image("stamp")
                    }
                    .buttonStyle(.stamp)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(SCColor.cellBackground)
            .cornerRadius(8)
            .shadow(color: SCColor.shadow, radius: 3, x: 0, y: 3)
        }
        .padding(24)
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView(shortWeekdays: [], day: Day(text: "", weekday: 0))
    }
}
