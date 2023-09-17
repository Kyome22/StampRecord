/*
 Log.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/17.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

struct Log: CustomStringConvertible {
    var date: Date
    var stamps: [Stamp]

    var description: String {
        var text = "date: \(date.timeIntervalSince1970)"
        stamps.forEach { stamp in
            text += "\n\t\(stamp)"
        }
        return text
    }
}
