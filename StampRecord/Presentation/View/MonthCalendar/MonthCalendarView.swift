/*
 MonthCalendarView.swift
 StampRecord

 Created by Takuto Nakamura on 2023/08/27.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI
import InfinitePaging

struct MonthCalendarView<MVM: MonthCalendarViewModel>: View {
    @StateObject var viewModel: MVM
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
                    viewModel.setMonthList()
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
                objects: $viewModel.monthList,
                pageAlignment: .horizontal,
                pagingHandler: { pageDirection in
                    viewModel.paging(with: pageDirection)
                },
                content: { month in
                    MonthView(
                        selectedDayID: $viewModel.selectedDayID,
                        device: device,
                        weekdays: viewModel.weekStartsAt.weekdays,
                        days: month.days,
                        removeStampHandler: { day, index in
                            try viewModel.removeStamp(day: day, index: index)
                        }
                    )
                }
            )
            .onChangeWithMigration(of: viewModel.weekStartsAt) {
                viewModel.setMonthList()
            }
        }
        .background(Color.appBackground)
        .onAppear {
            viewModel.selectedDayID = nil
        }
    }
}

#Preview {
    MonthCalendarView(viewModel: PreviewMock.MonthCalendarViewModelMock(),
                      device: .default)
}
