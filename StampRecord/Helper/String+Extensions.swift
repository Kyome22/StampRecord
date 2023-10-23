/*
 String+Extensions.swift
 StampRecord

 Created by Takuto Nakamura on 2023/10/13.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

extension String {
    static let weekStartsAt = "weekStartsAt"
    static let defaultPeriod = "defaultPeriod"

    var bundleString: String {
        guard let str = Bundle.main.object(forInfoDictionaryKey: self) as? String else {
            fatalError("bundleString key is not found.")
        }
        return str
    }
}
