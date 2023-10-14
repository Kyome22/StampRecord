/*
 SummaryTextFieldStyle.swift
StampRecord

 Created by Takuto Nakamura on 2023/10/10.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct SummaryTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(Color(.appBackground))
            .cornerRadius(8)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.cellBorder), lineWidth: 1)
            }
    }

}

extension TextFieldStyle where Self == SummaryTextFieldStyle {
    static var summary: SummaryTextFieldStyle {
        return SummaryTextFieldStyle()
    }
}
