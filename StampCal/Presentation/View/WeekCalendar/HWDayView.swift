/*
 HWDayView.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/25.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct HWDayView: View {
    @State var showStampPicker: Bool = false
    let shortWeekday: String
    let day: Day
    let putStampHandler: (Day, Stamp) -> Void
    let removeStampHandler: (Day, Int) -> Void

    var body: some View {
        HStack(spacing: 16) {
            wrapText(maxKey: "MMM", key: shortWeekday)
                .frame(maxHeight: .infinity)
                .padding(.horizontal, 4)
                .foregroundColor(Color.weekday(day.weekday))
                .background(Color(.cellBackground))
                .cornerRadius(8)
                .shadow(color: Color(.shadow), radius: 2, x: 0, y: 3)
            HStack(spacing: 0) {
                wrapText(maxKey: "88", key: day.text)
                    .frame(maxHeight: .infinity)
                    .padding(.horizontal, 4)
                    .foregroundColor(Color.weekday(day.weekday, day.isToday))
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.highlight(day.isToday))
                    }
                    .padding(4)
                Divider()
                    .overlay(Color(.cellBorder))
                    .padding(.vertical, 4)
                if let log = day.log {
                    OverlappingHStack(alignment: .leading, spacing: 4) {
                        ForEach(log.stamps.indices, id: \.self) { index in
                            Text(log.stamps[index].emoji)
                                .font(.largeTitle)
                                .padding(4)
                        }
                    }
                    .padding(4)
                } else {
                    Spacer()
                }
                Divider()
                    .overlay(Color(.cellBorder))
                    .padding(.vertical, 4)
                stampButton
                    .padding(.horizontal, 4)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .background(Color(.cellBackground))
            .cornerRadius(8)
            .shadow(color: Color(.shadow), radius: 2, x: 0, y: 3)
        }
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

struct HWDayView_Previews: PreviewProvider {
    static var previews: some View {
        HWDayView(shortWeekday: "",
                  day: Day(text: "", weekday: 0),
                  putStampHandler: { _, _ in },
                  removeStampHandler: { _, _ in })
    }
}
