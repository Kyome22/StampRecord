/*
 Date+Extensions.swift
StampRecord

 Created by Takuto Nakamura on 2023/09/07.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

extension Date {
    var title: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM, yyyy"
        return formatter.string(from: self)
    }
}
