/*
 ProcessInfo+Extensions.swift
 StampRecord

 Created by Takuto Nakamura on 2023/10/22.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

extension ProcessInfo {
    static var isUnitTesting: Bool {
        return Self.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
    static var isUITesting: Bool {
        return Self.processInfo.environment["EXEC_UITEST"] != nil
    }
    static var isCapturing: Bool {
        return Self.processInfo.environment["EXEC_CAPTURE"] != nil
    }
}
