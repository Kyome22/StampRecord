/*
 SettingsView.swift
 StampCal

 Created by Takuto Nakamura on 2023/10/12.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct SettingsView: View {
    @AppStorage(.weekStartsAt) var weekStartsAt: WeekStartsAt = .sunday

    var body: some View {
        NavigationView {
            VStack {
                List {
                    Picker(selection: $weekStartsAt) {
                        ForEach(WeekStartsAt.allCases) { weekStartsAt in
                            Text(weekStartsAt.label)
                                .tag(weekStartsAt)
                        }
                    } label: {
                        Text("weekStartsAt")
                    }
#if DEBUG
                    NavigationLink {
                        ColorDebugView()
                            .navigationTitle("debug")
                    } label: {
                         Label("debug", systemImage: "ladybug")
                    }
#endif
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    SettingsView()
}
