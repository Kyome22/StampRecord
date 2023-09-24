/*
 DayStampCardView.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/24.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct DayStampCardView: View {
    @State var showPopover: Bool = false
    let stamp: Stamp
    let removeStampHandler: () -> Void

    var body: some View {
        Button {
            showPopover = true
        } label: {
            VStack(spacing: 4) {
                Text(stamp.emoji)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.01)
                Text(stamp.summary)
                    .font(.caption)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .padding(8)
            .containerShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.innerCell)
        .popover(isPresented: $showPopover) {
            Button {
                removeStampHandler()
                showPopover = false
            } label: {
                Text("removeStamp")
            }
            .tint(SCColor.delete)
            .padding(16)
            .presentationCompactAdaptation(.popover)
        }
    }
}

struct DayStampCardView_Previews: PreviewProvider {
    static var previews: some View {
        DayStampCardView(stamp: Stamp(emoji: "", summary: ""), removeStampHandler: {})
    }
}
