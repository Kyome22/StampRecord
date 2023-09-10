/*
 AddNewStampViewModel.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/10.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

final class AddNewStampViewModel: ObservableObject {
    @Published var emoji: String = "🏖️"
    @Published var summary: String = ""
    @Published var showEmojiPicker: Bool = false

    init() {}
}
