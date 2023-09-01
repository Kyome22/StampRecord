/*
 WeekCalendarView.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/27.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct WeekCalendarView: View {
    @StateObject var viewModel = WeekCalendarViewModel()

    var body: some View {
        VStack {
            HStack {
                Button {
                    viewModel.previousWeek()
                } label: {
                    Image(systemName: "chevron.left")
                        .fontWeight(.semibold)
                }
                Text(verbatim: viewModel.title)
                    .frame(maxWidth: .infinity)
                Button {
                    viewModel.nextWeek()
                } label: {
                    Image(systemName: "chevron.right")
                        .fontWeight(.semibold)
                }
            }
            if viewModel.isPortrait {
                HStack {
                    VStack {
                        ForEach(viewModel.weekdays, id: \.self) { weekday in
                            Text(weekday)
                                .frame(width: 64)
                                .frame(maxHeight: .infinity)
                                .background(Color.white)
                                .cornerRadius(8)
                        }
                    }
                    VStack {
                        ForEach(viewModel.days) { day in
                            HStack {
                                wrapText(maxKey: "AA", key: viewModel.dayText(of: day.date))
                                    .foregroundColor(day.isToday ? .red : .primary)
                                    .padding(.horizontal, 8)
                                Text("😃")
                                    .font(.title)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(8)
                        }
                    }
                }
            } else {
                VStack {
                    HStack {
                        ForEach(viewModel.weekdays, id: \.self) { weekday in
                            Text(weekday)
                                .frame(height: 40)
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(8)
                        }
                    }
                    HStack {
                        ForEach(viewModel.days) { day in
                            VStack {
                                wrapText(maxKey: "AA", key: viewModel.dayText(of: day.date))
                                    .foregroundColor(day.isToday ? .red : .primary)
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
        .padding()
        .background(SCColor.background)
        .onRotate($viewModel.orientation)
    }
}

struct WeekCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        WeekCalendarView()
    }
}
