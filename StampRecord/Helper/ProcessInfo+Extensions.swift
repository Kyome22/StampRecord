/*
 ProcessInfo+Extensions.swift
 StampRecord

 Created by Takuto Nakamura on 2023/10/22.
*/

import Foundation

extension ProcessInfo {
    static var isUnitTesting: Bool {
        return Self.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
    static var isUITesting: Bool {
        return Self.processInfo.environment["EXEC_UITEST"] != nil
    }
}