/*
 WeekCalendarView.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/27.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct WeekCalendarView: View {
    @StateObject var viewModel = WeekCalendarViewModel()
    @Binding var isPhone: Bool

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
                objects: $viewModel.weekList,
                pagingHandler: { pageDirection in
                    viewModel.paging(with: pageDirection)
                },
                content: { week in
                    if isPhone {
                        HorizontalWeekView(shortWeekdays: viewModel.shortWeekdays, days: week.days)
                    } else {
                        VerticalWeekView(shortWeekdays: viewModel.shortWeekdays, days: week.days)
                    }
                }
            )
        }
        .padding(.vertical)
        .background(SCColor.appBackground)
    }
}

struct WeekCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        WeekCalendarView(isPhone: .constant(true))
    }
}
