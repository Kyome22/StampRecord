/*
 DebugView.swift
 StampCal

 Created by Takuto Nakamura on 2023/10/10.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct DebugView: View {
    var body: some View {
        VStack {
            Image(.stampFill)
                .frame(width: 100, height: 100)
                .fixedSize()
                .contextMenu {
                    Button {

                    } label: {
                        Text("Push Me")
                    }
                }
        }
    }
}

#Preview {
    DebugView()
}
