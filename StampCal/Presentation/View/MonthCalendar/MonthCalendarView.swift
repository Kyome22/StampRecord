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
        VStack(spacing: 0) {
            PagingHeaderView(
                title: $viewModel.title,
                pageBackwardHandler: {
                    viewModel.paging(with: .backward)
                },
                pageForwardHandler: {
                    viewModel.paging(with: .forward)
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
        .background(SCColor.appBackground)
    }
}

struct MonthCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        MonthCalendarView()
    }
}
