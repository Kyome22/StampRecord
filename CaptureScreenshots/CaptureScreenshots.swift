/*
 CaptureScreenshots.swift
 CaptureScreenshots

 Created by Takuto Nakamura on 2023/10/23.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import XCTest

final class CaptureScreenshots: XCTestCase {
    let app = XCUIApplication()

    private func capture(language: Language, device: Device, page: String) {
        let screenshot = app.windows.firstMatch.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.lifetime = .keepAlways
        attachment.name = "\(language.rawValue)_\(device.rawValue)_\(page)"
        add(attachment)
    }

    private func operate(language: Language, device: Device) {
        XCUIDevice.shared.orientation = device.orientation
        app.launchEnvironment = ["EXEC_CAPTURE": "true"]
        app.launchArguments = ["-AppleLanguages", "(\(language.rawValue))"]
        app.launch()

        capture(language: language, device: device, page: "stamps")

        app.buttons["Tab_DayCalendar"].tap()
        capture(language: language, device: device, page: "day")

        app.buttons["Tab_WeekCalendar"].tap()
        capture(language: language, device: device, page: "week")

        app.buttons["Tab_MonthCalendar"].tap()
        capture(language: language, device: device, page: "month")

        app.terminate()
    }

    func test_iPhone15ProMax() {
        operate(language: .en, device: .iPhone15ProMax)
        operate(language: .ja, device: .iPhone15ProMax)
    }

    func test_iPhone8Plus() {
        operate(language: .en, device: .iPhone8Plus)
        operate(language: .ja, device: .iPhone8Plus)
    }

    func test_iPadPro6th() {
        operate(language: .en, device: .iPadPro6th)
        operate(language: .ja, device: .iPadPro6th)
    }

    func test_iPadPro2nd() {
        operate(language: .en, device: .iPadPro2nd)
        operate(language: .ja, device: .iPadPro2nd)
    }
}

private enum Language: String {
    case en
    case ja
}

private enum Device: String {
    case iPhone15ProMax
    case iPhone8Plus
    case iPadPro6th
    case iPadPro2nd

    var orientation: UIDeviceOrientation {
        switch self {
        case .iPhone15ProMax: return .portrait
        case .iPhone8Plus:    return .portrait
        case .iPadPro6th:     return .landscapeLeft
        case .iPadPro2nd:     return .landscapeLeft
        }
    }
}
