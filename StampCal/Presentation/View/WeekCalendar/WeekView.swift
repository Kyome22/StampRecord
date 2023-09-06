/*
 WeekView.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/04.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct WeekView: View {
    let isPortrait: Bool
    let weekdays: [String]
    let days: [Day]

    var body: some View {
        Group {
            if isPortrait {
                portraitView
            } else {
                landscapeView
            }
        }
        .padding(8)
    }

    var portraitView: some View {
        HStack {
            VStack {
                ForEach(weekdays, id: \.self) { weekday in
                    Text(weekday)
                        .frame(width: 64)
                        .frame(maxHeight: .infinity)
                        .background(SCColor.cellBackground)
                        .cornerRadius(8)
                }
            }
            VStack {
                ForEach(days) { day in
                    HStack {
                        wrapText(maxKey: "AA", key: day.text)
                            .padding(.horizontal, 8)
                        Text("😃")
                            .font(.title)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .background(SCColor.cellBackground)
                    .cornerRadius(8)
                }
            }
        }
    }

    var landscapeView: some View {
        VStack {
            HStack {
                ForEach(weekdays, id: \.self) { weekday in
                    Text(weekday)
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(8)
                }
            }
            HStack {
                ForEach(days) { day in
                    VStack {
                        Text(day.text)
                            .padding(.vertical, 8)
                        Text("😃")
                            .font(.title)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .background(Color.white)
                    .cornerRadius(8)
                }
            }
        }
    }
}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        WeekView(isPortrait: true, weekdays: [], days: [])
    }
}
