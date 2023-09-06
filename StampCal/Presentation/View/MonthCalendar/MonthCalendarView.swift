/*
 MonthCalendarView.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/27.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct MonthCalendarView: View {
    @StateObject var viewModel = MonthCalendarViewModel()

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
                objects: $viewModel.monthList,
                pagingHandler: { pageDirection in
                    viewModel.paging(with: pageDirection)
                },
                content: { month in
                    MonthView(weekdays: viewModel.weekdays, days: month.days)
                }
            )
        }
        .padding(.vertical)
        .background(SCColor.appBackground)
    }
}

struct MonthCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        MonthCalendarView()
    }
}
