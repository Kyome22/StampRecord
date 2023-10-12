/*
 BackableModifier.swift
 StampCal

 Created by Takuto Nakamura on 2023/10/13.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct BackableModifier: ViewModifier {
    @Environment(\.dismiss) var dismiss

    func body(content: Content) -> some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .imageScale(.large)
                        .fontWeight(.bold)
                }
                Spacer()
            }
            .padding()
            content
            Spacer(minLength: 0)
        }
    }
}
