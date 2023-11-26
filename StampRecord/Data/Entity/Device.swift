/*
 Device.swift
 StampRecord

 Created by Takuto Nakamura on 2023/11/24.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import UIKit
import SwiftUI

enum DeviceIdiom {
    case iPhone
    case iPad

    init?(_ interfaceIdiom: UIUserInterfaceIdiom) {
        switch interfaceIdiom {
        case .phone:
            self = .iPhone
        case .pad:
            self = .iPad
        default:
            return nil
        }
    }
}

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

struct Device {
    var idiom: DeviceIdiom
    var orientation: DeviceOrientation

    static let `default` = Device(
        idiom: .iPhone,
        orientation: .portrait
    )

    var columnCount: Int {
        switch (idiom, orientation) {
        case (.iPhone, _):
            return 3
        case (.iPad, .portrait):
            return 5
        case (.iPad, .landscape):
            return 7
        }
    }

    var spacing: CGFloat {
        switch idiom {
        case .iPhone:
            return 8
        case .iPad:
            return 16
        }
    }

    var summaryFont: Font {
        switch idiom {
        case .iPhone:
            return .caption
        case .iPad:
            return .title2
        }
    }
}
