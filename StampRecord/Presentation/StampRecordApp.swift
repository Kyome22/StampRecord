/*
 StampRecordApp.swift
 StampRecord

 Created by Takuto Nakamura on 2023/10/14.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

@main
struct StampRecordApp: App {
    typealias SAM = StampRecordAppModelImpl
    @StateObject private var appModel = SAM()

    var body: some Scene {
        WindowGroup {
            ContentView<SAM>()
                .environmentObject(appModel)
        }
    }
}
