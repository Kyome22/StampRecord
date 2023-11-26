/*
 JudgeDeviceModifier.swift
 StampRecord

 Created by Takuto Nakamura on 2023/10/09.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct JudgeDeviceModifier: ViewModifier {
    @Binding var device: Device

    func body(content: Content) -> some View {
        content.onAppear {
            if let idiom = DeviceIdiom(UIDevice.current.userInterfaceIdiom) {
                self.device.idiom = idiom
            }
            if let orientation = DeviceOrientation(UIDevice.current.orientation) {
                self.device.orientation = orientation
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            if let orientation = DeviceOrientation(UIDevice.current.orientation) {
                self.device.orientation = orientation
            }
        }
    }
}
