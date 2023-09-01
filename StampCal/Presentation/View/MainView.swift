/*
 MainView.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/27.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            Text("stamps")
                .tabItem {
                    Label("stamps", systemImage: "pawprint.fill")
                }
            DayCalendarView()
                .tabItem {
                    Label("day", image: "calendar.day")
                }
            WeekCalendarView()
                .tabItem {
                    Label("week", image: "calendar.week")
                }
            MonthCalendarView()
                .tabItem {
                    Label("month", systemImage: "calendar")
                }
            PiyoView()
                .tabItem {
                    Label("settings", systemImage: "gearshape")
                }
        }
    }
}
