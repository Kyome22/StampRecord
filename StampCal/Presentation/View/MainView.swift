/*
 MainView.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/27.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct MainView: View {
    @State var isPhone: Bool = true

    var body: some View {
        TabView {
            Text("stamps")
                .tabItem {
                    Label("stamps", image: "stamp")
                }
            DayCalendarView()
                .tabItem {
                    Label("day", image: "calendar.day")
                }
            WeekCalendarView(isPhone: $isPhone)
                .tabItem {
                    if isPhone {
                        Label("week", image: "calendar.week.horizontal")
                    } else {
                        Label("week", image: "calendar.week.vertical")
                    }
                }
            MonthCalendarView()
                .tabItem {
                    Label("month", systemImage: "calendar")
                }
            Text("Hello")
                .tabItem {
                    Label("settings", systemImage: "gearshape")
                }
        }
        .onAppear {
            judgeDevice()
        }
    }

    func judgeDevice() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            isPhone = false
        }
    }
}
