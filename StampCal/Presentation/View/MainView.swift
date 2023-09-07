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
                    Label("stamps", image: "stamp")
                }
            DayCalendarView()
                .tabItem {
                    Label("day", image: "calendar.day")
                }
            WeekCalendarView()
                .tabItem {
                    Label("week", image: "calendar.week.horizontal")
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
    }
}
