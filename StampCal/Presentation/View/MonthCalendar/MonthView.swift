/*
 MonthView.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/06.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct MonthView: View {
    let weekdays: [String]
    let days: [Day]

    var body: some View {
        VStack {
            HStack {
                ForEach(weekdays, id: \.self) { weekday in
                    Text(weekday)
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .background(SCColor.cellBackground)
                        .cornerRadius(8)
                }
            }
            ForEach(days.chunked(by: 7)) { chunk in
                HStack {
                    ForEach(chunk.elements) { day in
                        VStack {
                            Text(day.text)
                                .padding(.vertical, 8)
                            Text("😃")
                                .font(.title2)
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
        MonthView(weekdays: [], days: [])
    }
}
