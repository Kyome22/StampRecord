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
    @Environment(\.scenePhase) var scenePhase
    let isPhone: Bool

    var body: some View {
        VStack(spacing: 0) {
            CalendarHeaderView(
                title: $viewModel.title,
                isDaySelected: Binding<Bool>(
                    get: { viewModel.selectedDayID != nil },
                    set: { _ in}
                ),
                showStampPicker: $viewModel.showStampPicker,
                stamps: $viewModel.stamps,
                resetHandler: {
                    viewModel.setDayList()
                },
                selectStampHandler: { stamp in
                    try viewModel.putStamp(stamp: stamp)
                    viewModel.showStampPicker = false
                }
            )
            InfinitePagingView(
                objects: $viewModel.dayList,
                pagingHandler: { pageDirection in
                    viewModel.paging(with: pageDirection)
                },
                content: { day in
                    DayView(
                        isPhone: isPhone,
                        day: day,
                        removeStampHandler: { day, index in
                            try viewModel.removeStamp(day: day, index: index)
                        }
                    )
                }
            )
        }
        .background(Color.appBackground)
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .active {
                viewModel.setToday()
            }
        }
    }
}

#Preview {
    DayCalendarView(viewModel: PreviewMock.DayCalendarViewModelMock(),
                    isPhone: true)
}
