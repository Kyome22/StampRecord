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
                                stampCard(stamp)
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

    private func stampCard(_ stamp: Stamp) -> some View {
        HStack(alignment: .center, spacing: 0) {
            Text(stamp.emoji)
                .font(.largeTitle)
                .padding(8)
                .overlay(alignment: .trailing) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 1)
                        .padding(.vertical, 4)
                }
            Text(stamp.summary)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 8)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(SCColor.cellBorder, lineWidth: 1)
        }
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView(shortWeekdays: [], day: Day(text: "", weekday: 0), putStampHandler: { _, _ in })
    }
}
