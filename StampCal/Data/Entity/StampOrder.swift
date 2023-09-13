/*
 StampOrder.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/13.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

enum StampOrderBy: String, Identifiable, CaseIterable {
    case createdDate
    case summary

    var id: String { rawValue }

    var label: LocalizedStringKey {
        return LocalizedStringKey(rawValue)
    }
}

enum StampOrderIn: String, Identifiable, CaseIterable {
    case ascending
    case descending

    var id: String { rawValue }

    var label: LocalizedStringKey {
        return LocalizedStringKey(rawValue)
    }
}
