/*
 StampRecordApp.swift
 StampRecord

 Created by Takuto Nakamura on 2023/10/14.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

@main
struct StampRecordApp: App {
    @StateObject private var appModel = StampRecordAppModelImpl()

    var body: some Scene {
        WindowGroup {
            ContentView<StampRecordAppModelImpl>()
                .environmentObject(appModel)
        }
    }
}
