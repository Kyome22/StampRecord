/*
 MonthCalendarView.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/27.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct MonthCalendarView: View {
    @StateObject var viewModel = MonthCalendarViewModel()

    var body: some View {
        VStack {
            HStack {
                Button {
                    viewModel.previousMonth()
                } label: {
                    Image(systemName: "chevron.left")
                        .fontWeight(.semibold)
                }
                Text(verbatim: viewModel.title)
                    .frame(maxWidth: .infinity)
                Button {
                    viewModel.nextMonth()
                } label: {
                    Image(systemName: "chevron.right")
                        .fontWeight(.semibold)
                }
            }
            .padding(.horizontal)
            HStack {
                ForEach(viewModel.weekdays, id: \.self) { weekday in
                    Text(weekday)
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                }
            }
            LazyVGrid(columns: viewModel.columns, spacing: 20) {
                ForEach(viewModel.days) { day in
                    Text(day.text)
                        .foregroundColor(day.isToday ? .red : (day.inMonth ? .primary : .secondary))
                        .frame(maxHeight: .infinity)
                }
            }
        }
        .padding()
        .background(SCColor.background)
    }
}

struct MonthCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        MonthCalendarView()
    }
}
