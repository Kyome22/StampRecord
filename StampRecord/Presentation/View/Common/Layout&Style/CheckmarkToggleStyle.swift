/*
 CheckmarkToggleStyle.swift
 StampRecord

 Created by Takuto Nakamura on 2023/11/13.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct CheckmarkToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 8) {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square.fill")
                .foregroundStyle(configuration.isOn ? Color.accentColor : Color.disabled)
            configuration.label
                .labelStyle(.titleOnly)
        }
        .onTapGesture {
            configuration.isOn.toggle()
        }
    }
}

extension ToggleStyle where Self == CheckmarkToggleStyle {
    static var checkmarkToggle: CheckmarkToggleStyle {
        return CheckmarkToggleStyle()
    }
}
