/*
 Weekday.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/06.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

struct Weekday: Identifiable {
    var index: Int
    var title: String
    var id: Int { index }
}
