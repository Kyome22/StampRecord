/*
 InnerCellButtonStyle.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/24.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct InnerCellButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(SCColor.appBackground.opacity(configuration.isPressed ? 0.7 : 0.0))
            .cornerRadius(8)
    }
}

extension ButtonStyle where Self == InnerCellButtonStyle {
    static var innerCell: InnerCellButtonStyle {
        return InnerCellButtonStyle()
    }
}
