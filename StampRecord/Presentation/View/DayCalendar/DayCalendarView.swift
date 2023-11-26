/*
 DayCalendarView.swift
 StampRecord

 Created by Takuto Nakamura on 2023/08/27.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI
import InfinitePaging

struct DayCalendarView<DVM: DayCalendarViewModel>: View {
    @StateObject var viewModel: DVM
    let device: Device

    var body: some View {
        VStack(spacing: 0) {
            CalendarHeaderView(
                title: $viewModel.title,
                isDaySelected: Binding<Bool>(
                    get: { viewModel.selectedDayID != nil },
                    set: { _ in}
                ),
                showStampFilter: $viewModel.showStampFilter,
                showStampPicker: $viewModel.showStampPicker,
                stamps: $viewModel.stamps,
                resetHandler: {
                    viewModel.setDayList()
                },
                updateFilterHandler: { state in
                    viewModel.updateFilter(state: state)
                },
                toggleFilterHandler: { stamp in
                    viewModel.toggleFilter(stamp: stamp)
                },
                selectStampHandler: { stamp in
                    try viewModel.putStamp(stamp: stamp)
                    viewModel.showStampPicker = false
                }
            )
            InfinitePagingView(
                objects: $viewModel.dayList,
                pageAlignment: .horizontal,
                pagingHandler: { pageDirection in
                    viewModel.paging(with: pageDirection)
                },
                content: { day in
                    DayView(
                        device: device,
                        day: day,
                        removeStampHandler: { day, index in
                            try viewModel.removeStamp(day: day, index: index)
                        }
                    )
                }
            )
        }
        .background(Color.appBackground)
    }
}

#Preview {
    DayCalendarView(viewModel: PreviewMock.DayCalendarViewModelMock(),
                    device: .default)
}
