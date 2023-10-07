/*
 WeekCalendarView.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/27.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct WeekCalendarView<WVM: WeekCalendarViewModel>: View {
    @StateObject var viewModel: WVM
    @Binding var isPhone: Bool

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
                objects: $viewModel.weekList,
                pagingHandler: { pageDirection in
                    viewModel.paging(with: pageDirection)
                },
                content: { week in
                    if isPhone {
                        HorizontalWeekView(
                            shortWeekdays: viewModel.shortWeekdays,
                            days: week.days,
                            putStampHandler: { day, stamp in
                                viewModel.putStamp(day: day, stamp: stamp)
                            },
                            removeStampHandler: { day, index in
                                viewModel.removeStamp(day: day, index: index)
                            }
                        )
                    } else {
                        VerticalWeekView(shortWeekdays: viewModel.shortWeekdays, days: week.days)
                    }
                }
            )
        }
        .background(Color(.appBackground))
    }
}

struct WeekCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        WeekCalendarView(viewModel: PreviewMock.WeekCalendarViewModelMock(),
                         isPhone: .constant(true))
    }
}
