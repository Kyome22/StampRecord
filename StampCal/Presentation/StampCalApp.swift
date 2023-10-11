/*
 StampCalApp.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/20.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

@main
struct StampCalApp: App {
    @StateObject private var appModel = StampCalAppModelImpl()

    var body: some Scene {
        WindowGroup {
            ContentView<StampCalAppModelImpl>()
                .environmentObject(appModel)
        }
    }
}
