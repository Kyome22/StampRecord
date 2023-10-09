/*
 MonthCalendarView.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/27.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct MonthCalendarView<MVM: MonthCalendarViewModel>: View {
    @StateObject var viewModel: MVM
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
                resetHandler: {
                    viewModel.setMonthList()
                },
                selectStampHandler: { stamp in
                    viewModel.putStamp(stamp: stamp)
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
                        shortWeekdays: viewModel.shortWeekdays,
                        days: month.days,
                        removeStampHandler: { day, index in
                            viewModel.removeStamp(day: day, index: index)
                        }
                    )
                }
            )
        }
        .background(Color(.appBackground))
        .onAppear {
            viewModel.reloadLog()
        }
    }
}

#Preview {
    MonthCalendarView(viewModel: PreviewMock.MonthCalendarViewModelMock(),
                      isPhone: true,
                      orientation: .portrait)
}
