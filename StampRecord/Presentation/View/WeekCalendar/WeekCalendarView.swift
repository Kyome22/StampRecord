/*
 WeekCalendarView.swift
 StampRecord

 Created by Takuto Nakamura on 2023/08/27.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI
import InfinitePaging

struct WeekCalendarView<WVM: WeekCalendarViewModel>: View {
    @StateObject var viewModel: WVM
    let device: Device

    var body: some View {
        VStack(spacing: 0) {
            CalendarHeaderView(
                title: $viewModel.title,
                isDaySelected: Binding<Bool>(
                    get: { viewModel.selectedDayID != nil },
                    set: { _ in }
                ),
                showStampFilter: $viewModel.showStampFilter,
                showStampPicker: $viewModel.showStampPicker,
                stamps: $viewModel.stamps,
                resetHandler: {
                    viewModel.setWeekList()
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
                objects: $viewModel.weekList,
                pageAlignment: .horizontal,
                pagingHandler: { pageDirection in
                    viewModel.paging(with: pageDirection)
                },
                content: { week in
                    switch device.idiom {
                    case .iPhone:
                        HorizontalWeekView(
                            selectedDayID: $viewModel.selectedDayID,
                            weekdays: viewModel.weekStartsAt.weekdays,
                            days: week.days,
                            removeStampHandler: { day, stamp in
                                try viewModel.removeStamp(day: day, stamp: stamp)
                            }
                        )
                    case .iPad:
                        VerticalWeekView(
                            selectedDayID: $viewModel.selectedDayID,
                            weekdays: viewModel.weekStartsAt.weekdays,
                            days: week.days,
                            removeStampHandler: { day, stamp in
                                try viewModel.removeStamp(day: day, stamp: stamp)
                            }
                        )
                    }
                }
            )
            .onChangeWithMigration(of: viewModel.weekStartsAt) {
                viewModel.setWeekList()
            }
        }
        .background(Color.appBackground)
        .onAppear {
            viewModel.selectedDayID = nil
        }
    }
}

#Preview {
    WeekCalendarView(viewModel: PreviewMock.WeekCalendarViewModelMock(),
                     device: .default)
}
