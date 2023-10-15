/*
 WeekCalendarView.swift
StampRecord

 Created by Takuto Nakamura on 2023/08/27.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct WeekCalendarView<WVM: WeekCalendarViewModel>: View {
    @StateObject var viewModel: WVM
    let isPhone: Bool

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
                    viewModel.setWeekList()
                },
                selectStampHandler: { stamp in
                    viewModel.putStamp(stamp: stamp)
                    viewModel.showStampPicker = false
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
                            selectedDayID: $viewModel.selectedDayID,
                            weekdays: viewModel.weekStartsAt.weekdays,
                            days: week.days,
                            removeStampHandler: { day, index in
                                viewModel.removeStamp(day: day, index: index)
                            }
                        )
                    } else {
                        VerticalWeekView(
                            selectedDayID: $viewModel.selectedDayID,
                            weekdays: viewModel.weekStartsAt.weekdays,
                            days: week.days,
                            removeStampHandler: { day, index in
                                viewModel.removeStamp(day: day, index: index)
                            }
                        )
                    }
                }
            )
            .onChange(of: viewModel.weekStartsAt) { _ in
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
                     isPhone: true)
}
