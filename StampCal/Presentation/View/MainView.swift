/*
 MainView.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/27.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct MainView<SAM: StampCalAppModel>: View {
    @EnvironmentObject private var appModel: SAM
    @State var isPhone: Bool = true

    var body: some View {
        TabView(selection: $appModel.tabSelection) {
            Group {
                StampsView(viewModel: StampsViewModelImpl(appModel.stampRepository))
                    .tabItem {
                        Label("stamps", image: "stamp.fill")
                    }
                    .tag(Tabs.stamps)
                DayCalendarView(viewModel: DayCalendarViewModelImpl(appModel.stampRepository, appModel.logRepository))
                    .tabItem {
                        Label("day", image: "calendar.day")
                    }
                    .tag(Tabs.dayCalendar)
                WeekCalendarView(viewModel: WeekCalendarViewModelImpl(appModel.stampRepository, appModel.logRepository), isPhone: $isPhone)
                    .tabItem {
                        if isPhone {
                            Label("week", image: "calendar.week.horizontal")
                        } else {
                            Label("week", image: "calendar.week.vertical")
                        }
                    }
                    .tag(Tabs.weekCalendar)
                MonthCalendarView(viewModel: MonthCalendarViewModelImpl())
                    .tabItem {
                        Label("month", systemImage: "calendar")
                    }
                    .tag(Tabs.monthCalendar)
               FontView()
                    .tabItem {
                        Label("settings", systemImage: "gearshape")
                    }
                    .tag(Tabs.settings)
            }
            .toolbarBackground(Color(.toolbarBackground), for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
        }
        .onAppear {
            judgeDevice()
        }
    }

    private func judgeDevice() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            isPhone = false
        }
    }
}
