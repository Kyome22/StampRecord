//
//  StampRecordApp.swift
//  StampRecord
//
//  Created by Takuto Nakamura on 2023/10/14.
//

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
