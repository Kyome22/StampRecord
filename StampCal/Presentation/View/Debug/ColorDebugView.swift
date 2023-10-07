/*
 ColorDebugView.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/21.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct ColorDebugView: View {
    let colors: [Color]

    init() {
        colors = [
            Color(.appAccent),
            Color(.appBackground),
            Color(.cellBackground),
            Color(.cellBorder),
            Color(.cellHighlightStrong),
            Color(.cellHighlightWeek),
            Color(.delete),
            Color(.cellBlue),
            Color(.cellRed)
        ]
    }

    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 16) {
                ForEach(colors, id: \.hashValue) { color in
                    color
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.horizontal, 16)
                }
            }
            .padding(.vertical, 16)
            .background(Color.white)
            .environment(\.colorScheme, .light)
            VStack(spacing: 16) {
                ForEach(colors, id: \.hashValue) { color in
                    color
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.horizontal, 16)
                }
            }
            .padding(.vertical, 16)
            .background(Color.black)
            .environment(\.colorScheme, .dark)
        }
    }
}

struct ColorDebugView_Previews: PreviewProvider {
    static var previews: some View {
        ColorDebugView()
    }
}
