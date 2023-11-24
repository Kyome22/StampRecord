/*
 ContentView.swift
 StampRecord

 Created by Takuto Nakamura on 2023/10/14.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct ContentView<SAM: StampRecordAppModel>: View {
    @EnvironmentObject private var appModel: SAM
    @State var isPhone: Bool = true
    @State var orientation: DeviceOrientation = .portrait

    var body: some View {
        TabView(selection: $appModel.tabSelection) {
            Group {
                StampsView(
                    viewModel: SAM.SVM(appModel.stampRepository),
                    isPhone: isPhone
                )
                .tabItem {
                    Label {
                        Text("stamps")
                    } icon: {
                        Image(.stampFill)
                    }
                    .accessibilityIdentifier("Tab_Stamps")
                }
                .tag(Tab.stamps)
                DayCalendarView(
                    viewModel: SAM.DVM(appModel.stampRepository, 
                                       appModel.logRepository,
                                       appModel.todayRepository),
                    isPhone: isPhone
                )
                .tabItem {
                    Label {
                        Text("day")
                    } icon: {
                        Image(.calendarDay)
                    }
                    .accessibilityIdentifier("Tab_DayCalendar")
                }
                .tag(Tab.dayCalendar)
                WeekCalendarView(
                    viewModel: SAM.WVM(appModel.stampRepository,
                                       appModel.logRepository,
                                       appModel.todayRepository),
                    isPhone: isPhone
                )
                .tabItem {
                    Label {
                        Text("week")
                    } icon: {
                        if isPhone {
                            Image(.calendarWeekHorizontal)
                        } else {
                            Image(.calendarWeekVertical)
                        }
                    }
                    .accessibilityIdentifier("Tab_WeekCalendar")
                }
                .tag(Tab.weekCalendar)
                MonthCalendarView(
                    viewModel: SAM.MVM(appModel.stampRepository,
                                       appModel.logRepository,
                                       appModel.todayRepository),
                    isPhone: isPhone,
                    orientation: orientation
                )
                .tabItem {
                    Label("month", systemImage: "calendar")
                        .accessibilityIdentifier("Tab_MonthCalendar")
                }
                .tag(Tab.monthCalendar)
                SettingsView(viewModel: SAM.SeVM())
                    .tabItem {
                        Label("settings", systemImage: "gearshape")
                            .accessibilityIdentifier("Tab_Settings")
                    }
                    .tag(Tab.settings)
            }
            .toolbarBackground(Color.toolbarBackground, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
        }
        .onJudgeDevice($isPhone)
        .onJudgeOrientation($orientation)
    }
}

#Preview {
    ContentView<PreviewMock.StampRecordAppModelMock>()
        .environmentObject(PreviewMock.StampRecordAppModelMock())
}
