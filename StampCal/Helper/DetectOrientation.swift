/*
 DetectOrientation.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/29.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct DetectOrientation: ViewModifier {
    @Binding var orientation: UIDeviceOrientation

    func body(content: Content) -> some View {
        content
            .onAppear {
                orientation = UIDevice.current.orientation
            }
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                orientation =  UIDevice.current.orientation
            }
    }
}
