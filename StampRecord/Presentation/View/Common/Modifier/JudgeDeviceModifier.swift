/*
 JudgeDeviceModifier.swift
 StampRecord

 Created by Takuto Nakamura on 2023/10/09.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct JudgeDeviceModifier: ViewModifier {
    @Binding var isPhone: Bool

    func body(content: Content) -> some View {
        content.onAppear {
            isPhone = !(UIDevice.current.userInterfaceIdiom == .pad)
        }
    }
}
