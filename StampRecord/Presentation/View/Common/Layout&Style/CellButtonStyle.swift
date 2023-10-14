/*
 CellButtonStyle.swift
StampRecord

 Created by Takuto Nakamura on 2023/09/23.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct CellButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color(.cellBackground).opacity(configuration.isPressed ? 0.5 : 1.0))
            .cornerRadius(8)
    }
}

extension ButtonStyle where Self == CellButtonStyle {
    static var cell: CellButtonStyle {
        return CellButtonStyle()
    }
}
