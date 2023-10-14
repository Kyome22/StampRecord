/*
 JudgeOrientationModifier.swift
StampRecord

 Created by Takuto Nakamura on 2023/08/29.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

enum DeviceOrientation {
    case portrait
    case landscape

    init?(_ orientation: UIDeviceOrientation) {
        switch orientation {
        case .portrait, .portraitUpsideDown:
            self = .portrait
        case .landscapeLeft, .landscapeRight:
            self = .landscape
        default:
            return nil
        }
    }
}

struct JudgeOrientationModifier: ViewModifier {
    @Binding var orientation: DeviceOrientation

    func body(content: Content) -> some View {
        content
            .onAppear {
                if let orientation = DeviceOrientation(UIDevice.current.orientation) {
                    self.orientation = orientation
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                if let orientation = DeviceOrientation(UIDevice.current.orientation) {
                    self.orientation = orientation
                }
            }
    }
}
