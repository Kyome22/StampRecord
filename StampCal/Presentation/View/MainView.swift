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
        TabView {
            Group {
                StampsView(viewModel: StampsViewModelImpl(appModel.stampRepository))
                    .tabItem {
                        Label("stamps", image: "stamp")
                    }
                DayCalendarView(viewModel: DayCalendarViewModelImpl())
                    .tabItem {
                        Label("day", image: "calendar.day")
                    }
                WeekCalendarView(viewModel: WeekCalendarViewModelImpl(), isPhone: $isPhone)
                    .tabItem {
                        if isPhone {
                            Label("week", image: "calendar.week.horizontal")
                        } else {
                            Label("week", image: "calendar.week.vertical")
                        }
                    }
                MonthCalendarView(viewModel: MonthCalendarViewModelImpl())
                    .tabItem {
                        Label("month", systemImage: "calendar")
                    }
                Text("Hello World")
                    .tabItem {
                        Label("settings", systemImage: "gearshape")
                    }
            }
            .toolbarBackground(SCColor.toolbarBackground, for: .tabBar)
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
