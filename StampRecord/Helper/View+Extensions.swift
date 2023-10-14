/*
 View+Extensions.swift
StampRecord

 Created by Takuto Nakamura on 2023/08/28.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

extension View {
    func wrapText(
        maxKey: String,
        key: String
    ) -> some View {
        return Text(maxKey)
            .hidden()
            .overlay(alignment: .center) {
                Text(key)
            }
            .fixedSize()
    }

    func onJudgeDevice(_ isPhone: Binding<Bool>) -> some View {
        return modifier(JudgeDeviceModifier(isPhone: isPhone))
    }

    func onJudgeOrientation(_ orientation: Binding<DeviceOrientation>) -> some View {
        return modifier(JudgeOrientationModifier(orientation: orientation))
    }

    func backable() -> some View {
        return modifier(BackableModifier())
    }
}
