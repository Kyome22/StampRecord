/*
 DeleteButtonStyle.swift
 StampRecord

 Created by Takuto Nakamura on 2023/09/17.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct DeleteButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .foregroundStyle(Color.delete)
            .background(Color.delete.opacity(configuration.isPressed ? 0.12 : 0.0))
            .cornerRadius(8)
            .contentShape(RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.delete, lineWidth: 1)
            }
    }
}

extension ButtonStyle where Self == DeleteButtonStyle {
    static var delete: DeleteButtonStyle {
        return DeleteButtonStyle()
    }
}
