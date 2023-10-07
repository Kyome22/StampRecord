/*
 DayView.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/06.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct DayView: View {
    @State var showStampPicker: Bool = false
    let shortWeekdays: [String]
    let day: Day
    let putStampHandler: (Day, Stamp) -> Void
    let removeStampHandler: (Day, Int) -> Void
    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 8), count: 3)

    var body: some View {
        VStack(spacing: 24) {
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
                        RoundedRectangle(cornerRadius: 8)
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
                Divider()
                    .overlay(Color(.cellBorder))
                    .padding(.horizontal, 8)
                HStack {
                    Spacer()
                    stampButton
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color(.cellBackground))
            .cornerRadius(8)
            .shadow(color: Color(.shadow), radius: 3, x: 0, y: 3)
        }
        .padding(24)
    }

    var stampButton: some View {
        Button {
            showStampPicker = true
        } label: {
            Image("stamp")
        }
        .buttonStyle(.stamp)
        .stampPicker(
            isPresented: $showStampPicker,
            stamps: Stamp.dummy,
            selectStampHandler: { stamp in
                putStampHandler(day, stamp)
                showStampPicker = false
            },
            attachmentAnchor: .point(.center)
        )
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView(shortWeekdays: [],
                day: Day(text: "", weekday: 0),
                putStampHandler: { _, _ in },
                removeStampHandler: { _, _ in })
    }
}
