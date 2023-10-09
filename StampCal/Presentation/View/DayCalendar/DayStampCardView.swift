/*
 DayStampCardView.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/24.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct DayStampCardView: View {
    @State var showDialog: Bool = false
    let stamp: Stamp
    let removeStampHandler: () -> Void

    var body: some View {
        Button {
            showDialog = true
        } label: {
            VStack(spacing: 4) {
                Text(stamp.emoji)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.01)
                Text(stamp.summary)
                    .font(.caption)
                    .lineLimit(1)
                    .minimumScaleFactor(0.05)
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .padding(8)
            .containerShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.innerCell)
        .confirmationDialog("", isPresented: $showDialog, titleVisibility: .hidden) {
            Button(role: .destructive) {
                removeStampHandler()
            } label: {
                Label {
                    Text("removeStamp\(stamp.emoji)")
                } icon: {
                    Image(.stampFillMinus)
                }
            }
        }
    }
}

#Preview {
    DayStampCardView(stamp: Stamp(emoji: "", summary: ""),
                     removeStampHandler: {})
}
