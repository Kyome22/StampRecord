/*
 SettingsView.swift
 StampCal

 Created by Takuto Nakamura on 2023/10/12.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct SettingsView: View {
    @AppStorage(.weekStartsAt) var weekStartsAt: WeekStartsAt = .sunday
#if DEBUG
    @State var showDebugDialog: Bool = false
#endif

    var body: some View {
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
                Button {
                    showDebugDialog = true
                } label: {
                    Label("debug", systemImage: "ladybug")
                }
                .fullScreenCover(isPresented: $showDebugDialog) {
                    ColorDebugView()
                        .backable()
                }
#endif
            }
        }
    }
}

#Preview {
    SettingsView()
}
