/*
 StampCardView.swift
 StampCal

 Created by Takuto Nakamura on 2023/10/08.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct StampCardView: View {
    @State var showDialog: Bool = false
    @State var longPressed: Bool = false
    let stamp: Stamp
    let removeStampHandler: () -> Void
    let longPressHandler: () -> Void

    var body: some View {
        Button {
            if longPressed {
                longPressHandler()
                longPressed = false
            } else {
                showDialog = true
            }
        } label: {
            Text(stamp.emoji)
                .font(.system(size: 200))
                .minimumScaleFactor(0.01)
                .padding(4)
                .containerShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.innerCell)
        .simultaneousGesture(
            LongPressGesture().onEnded { _ in
                longPressed = true
            }
        )
        .confirmationDialog("", isPresented: $showDialog, titleVisibility: .hidden) {
            Button(role: .destructive) {
                removeStampHandler()
            } label: {
                Label {
                    Text("removeStamp\(stamp.emoji)")
                } icon: {
                    Image(.stampFillMinus)
                }
                .labelStyle(.titleAndIcon)
            }
        }
    }
}

#Preview {
    StampCardView(stamp: Stamp(emoji: "", summary: ""), 
                  removeStampHandler: {},
                  longPressHandler: {})
}
