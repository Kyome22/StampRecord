/*
 Device.swift
 StampRecord

 Created by Takuto Nakamura on 2023/11/24.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import UIKit

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

    static let `default` = Device(idiom: .iPhone, orientation: .portrait)

    var columnCount: Int {
        switch (idiom, orientation) {
        case (.iPhone, _):
            return 3
        case (.iPad, .portrait):
            return 5 // 画面サイズによって変更したい
        case (.iPad, .landscape):
            return 5
        }
    }
}
