/*
 SettingsViewModel.swift
 StampRecord

 Created by Takuto Nakamura on 2023/10/13.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

protocol SettingsViewModel: ObservableObject {
    var weekStartsAt: WeekStartsAt { get set }
    var defaultPeriod: Period { get set }
    var showDebugDialog: Bool { get set }
    var version: String { get }

    init()

    func openProductPage()
}

final class SettingsViewModelImpl: SettingsViewModel {
    @AppStorage(.weekStartsAt) var weekStartsAt: WeekStartsAt = .sunday
    @AppStorage(.defaultPeriod) var defaultPeriod: Period = .day
    @Published var showDebugDialog: Bool = false

    let version: String

    init() {
        version = "CFBundleShortVersionString".bundleString
    }

    func openProductPage() {
        if let url = URL(string: String(localized: "productPageURL")) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class SettingsViewModelMock: SettingsViewModel {
        @Published var weekStartsAt: WeekStartsAt = .sunday
        @Published var defaultPeriod: Period = .day
        @Published var showDebugDialog: Bool = false
        let version: String = "0.0"

        init() {}

        func openProductPage() {}
    }
}
