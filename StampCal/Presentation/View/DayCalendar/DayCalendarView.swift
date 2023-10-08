/*
 DayCalendarView.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/27.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct DayCalendarView<DVM: DayCalendarViewModel>: View {
    @StateObject var viewModel: DVM
    @Binding var isPhone: Bool

    var body: some View {
        VStack(spacing: 0) {
            CalendarHeaderView(
                title: $viewModel.title,
                daySelected: Binding<Bool>(
                    get: { viewModel.selectedDayID != nil },
                    set: { _ in}
                ),
                showStampPicker: $viewModel.showStampPicker,
                resetHandler: {
                    viewModel.setDayList()
                },
                selectStampHandler: { stamp in
                    viewModel.putStamp(stamp: stamp)
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
                        shortWeekdays: viewModel.shortWeekdays,
                        day: day,
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

struct DayCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        DayCalendarView(viewModel: PreviewMock.DayCalendarViewModelMock(),
                        isPhone: .constant(true))
    }
}
