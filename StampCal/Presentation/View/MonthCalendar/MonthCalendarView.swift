/*
 MonthCalendarView.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/27.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct MonthCalendarView<MVM: MonthCalendarViewModel>: View {
    @StateObject var viewModel: MVM

    var body: some View {
        VStack(spacing: 0) {
            CalendarHeaderView(
                title: $viewModel.title,
                daySelected: .constant(true),
                jumpTodayHandler: {

                },
                addStampHandler: {

                }
            )
            InfinitePagingView(
                objects: $viewModel.monthList,
                pagingHandler: { pageDirection in
                    viewModel.paging(with: pageDirection)
                },
                content: { month in
                    MonthView(shortWeekdays: viewModel.shortWeekdays, days: month.days)
                }
            )
        }
        .background(Color(.appBackground))
    }
}

struct MonthCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        MonthCalendarView(viewModel: PreviewMock.MonthCalendarViewModelMock())
    }
}
