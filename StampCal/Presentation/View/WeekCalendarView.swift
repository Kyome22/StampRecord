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
            InfinitePagingView(
                title: $viewModel.title,
                objects: $viewModel.weekList,
                pagingHandler: { pageDirection in
                    viewModel.paging(with: pageDirection)
                },
                content: { week in
                    WeekView(
                        isPortrait: viewModel.isPortrait,
                        weekdays: viewModel.weekdays,
                        days: week.days
                    )
                }
            )
        }
        .padding(.vertical)
        .background(SCColor.background)
        .onRotate($viewModel.orientation)
    }
}

struct WeekCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        WeekCalendarView()
    }
}
