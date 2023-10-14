/*
 SettingsView.swift
StampRecord

 Created by Takuto Nakamura on 2023/10/12.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct SettingsView<SVM: SettingsViewModel>: View {
    @StateObject var viewModel: SVM

    var body: some View {
        VStack {
            List {
                Section("settings") {
                    Picker(selection: $viewModel.weekStartsAt) {
                        ForEach(WeekStartsAt.allCases) { weekStartsAt in
                            Text(weekStartsAt.label)
                                .tag(weekStartsAt)
                        }
                    } label: {
                        Text("weekStartsAt")
                    }
                    Picker(selection: $viewModel.defaultPeriod) {
                        ForEach(Period.allCases) { period in
                            Text(period.label)
                                .tag(period)
                        }
                    } label: {
                        Text("defaultPeriod")
                    }
                }
                Section("support") {
                    LabeledContent("version") {
                        Text(viewModel.version)
                    }
                    LabeledContent("developer") {
                        Text("developerName")
                    }
                    LabeledContent("productPage") {
                        Button {
                            viewModel.openProductPage()
                        } label: {
                            Text("open")
                        }
                    }
                }
#if DEBUG
                Button {
                    viewModel.showDebugDialog = true
                } label: {
                    Label("debug", systemImage: "ladybug")
                }
                .fullScreenCover(isPresented: $viewModel.showDebugDialog) {
                    ColorDebugView()
                        .backable()
                }
#endif
            }
        }
    }
}

#Preview {
    SettingsView(viewModel: PreviewMock.SettingsViewModelMock())
}
