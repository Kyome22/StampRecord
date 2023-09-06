/*
 DayCalendarView.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/27.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct DayCalendarView: View {
    @StateObject var viewModel = DayCalendarViewModel()

    var body: some View {
        VStack {
            HStack {
                Button {
                    viewModel.paging(with: .backward)
                } label: {
                    Image(systemName: "chevron.left")
                        .fontWeight(.semibold)
                }
                Text(verbatim: viewModel.title)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                Button {
                    viewModel.paging(with: .forward)
                } label: {
                    Image(systemName: "chevron.right")
                        .fontWeight(.semibold)
                }
            }
            .padding(.horizontal)
            InfinitePagingView(
                objects: $viewModel.dayList,
                pagingHandler: { pageDirection in
                    viewModel.paging(with: pageDirection)
                },
                content: { day in
                    DayView(shortWeekdays: viewModel.shortWeekdays, day: day)
                }
            )
        }
        .padding(.vertical)
        .background(SCColor.appBackground)
    }
}

struct DayCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        DayCalendarView()
    }
}
