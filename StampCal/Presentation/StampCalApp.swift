/*
 StampCalApp.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/20.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

@main
struct StampCalApp: App {
    @StateObject var appModel = StampCalAppModel()

    var body: some Scene {
        WindowGroup {
//            InfinitePagingView()
            MainView()
//            ContentView()
//                .environment(\.managedObjectContext, appModel.persistenceController.container.viewContext)
        }
    }
}
