/*
 StampButtonStyle.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/18.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct StampButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .foregroundColor(Color.gray)
            .aspectRatio(1, contentMode: .fit)
            .contentShape(Circle())
            .background {
                Circle()
                    .fill(SCColor.stampBackground)
                    .shadow(color: configuration.isPressed ? SCColor.accent : Color.clear, radius: 3)
            }
    }
}

extension ButtonStyle where Self == StampButtonStyle {
    static var stamp: StampButtonStyle {
        return StampButtonStyle()
    }
}
