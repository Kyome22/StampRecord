/*
 DayCalendarView.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/27.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct DayCalendarView<DVM: DayCalendarViewModel>: View {
    @StateObject var viewModel: DVM

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
                objects: $viewModel.dayList,
                pagingHandler: { pageDirection in
                    viewModel.paging(with: pageDirection)
                },
                content: { day in
                    DayView(
                        shortWeekdays: viewModel.shortWeekdays,
                        day: day,
                        putStampHandler: { day, stamp in
                            viewModel.putStamp(day: day, stamp: stamp)
                        },
                        removeStampHandler: { day, index in
                            viewModel.removeStamp(day: day, index: index)
                        }
                    )
                }
            )
        }
        .background(SCColor.appBackground)
    }
}

struct DayCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        DayCalendarView(viewModel: PreviewMock.DayCalendarViewModelMock())
    }
}
