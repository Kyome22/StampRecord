/*
 DayView.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/06.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct DayView: View {
    let columns: [GridItem]
    let shortWeekdays: [String]
    let day: Day
    let removeStampHandler: (Day, Int) -> Void

    init(
        isPhone: Bool,
        shortWeekdays: [String],
        day: Day,
        removeStampHandler: @escaping (Day, Int) -> Void
    ) {
        self.columns = Array(repeating: .init(.flexible(), spacing: 8), count: isPhone ? 3 : 5)
        self.shortWeekdays = shortWeekdays
        self.day = day
        self.removeStampHandler = removeStampHandler
    }

    var body: some View {
        VStack(spacing: 16) {
            Text(shortWeekdays[day.weekday])
                .font(.title2)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .foregroundColor(Color.weekday(day.weekday))
                .background(Color(.cellBackground))
                .cornerRadius(8)
                .shadow(color: Color(.shadow), radius: 3, x: 0, y: 3)
            VStack(spacing: 0) {
                Text(day.text)
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding(4)
                    .foregroundColor(Color.weekday(day.weekday, day.isToday))
                    .background {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.highlight(day.isToday))
                    }
                    .padding(4)
                Divider()
                    .overlay(Color(.cellBorder))
                    .padding(.horizontal, 8)
                ScrollView(.vertical, showsIndicators: false) {
                    if let log = day.log {
                        LazyVGrid(columns: columns, spacing: 8) {
                            ForEach(log.stamps.indices, id: \.self) { index in
                                DayStampCardView(stamp: log.stamps[index]) {
                                    removeStampHandler(day, index)
                                }
                            }
                        }
                        .padding(8)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color(.cellBackground))
            .cornerRadius(8)
            .shadow(color: Color(.shadow), radius: 3, x: 0, y: 3)
        }
        .padding(16)
    }
}

#Preview {
    DayView(isPhone: true,
            shortWeekdays: [],
            day: Day(text: "", weekday: 0),
            removeStampHandler: { _, _ in })
}
