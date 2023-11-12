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
    @Environment(\.scenePhase) var scenePhase
    let isPhone: Bool
    let orientation: DeviceOrientation

    var body: some View {
        VStack(spacing: 0) {
            CalendarHeaderView(
                title: $viewModel.title,
                isDaySelected: Binding<Bool>(
                    get: { viewModel.selectedDayID != nil },
                    set: { _ in }
                ),
                showStampPicker: $viewModel.showStampPicker,
                stamps: $viewModel.stamps,
                resetHandler: {
                    viewModel.setMonthList()
                },
                selectStampHandler: { stamp in
                    try viewModel.putStamp(stamp: stamp)
                    viewModel.showStampPicker = false
                }
            )
            InfinitePagingView(
                objects: $viewModel.monthList,
                pagingHandler: { pageDirection in
                    viewModel.paging(with: pageDirection)
                },
                content: { month in
                    MonthView(
                        selectedDayID: $viewModel.selectedDayID,
                        isPhone: isPhone,
                        orientation: orientation,
                        weekdays: viewModel.weekStartsAt.weekdays,
                        days: month.days,
                        removeStampHandler: { day, index in
                            try viewModel.removeStamp(day: day, index: index)
                        }
                    )
                }
            )
            .onChange(of: viewModel.weekStartsAt) { _, _ in
                viewModel.setMonthList()
            }
        }
        .background(Color.appBackground)
        .onAppear {
            viewModel.selectedDayID = nil
        }
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .active {
                viewModel.setToday()
            }
        }
    }
}

#Preview {
    MonthCalendarView(viewModel: PreviewMock.MonthCalendarViewModelMock(),
                      isPhone: true,
                      orientation: .portrait)
}
