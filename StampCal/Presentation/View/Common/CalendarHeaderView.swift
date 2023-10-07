/*
 CalendarHeaderView.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/08.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct CalendarHeaderView: View {
    @Binding var title: String
    @Binding var daySelected: Bool
    let jumpTodayHandler: () -> Void
    let addStampHandler: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HeaderHStack {
                Button {
                    jumpTodayHandler()
                } label: {
                    Text(Image(systemName: "arrow.uturn.right"))
                        .font(.title2)
                }
                .buttonStyle(.square)
                Text(verbatim: title)
                    .font(.body)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                Button {
                    addStampHandler()
                } label: {
                    Text(Image(.stamp))
                        .font(.title2)
                }
                .buttonStyle(.square)
                .disabled(!daySelected)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            Divider()
        }
        .background(Color(.toolbarBackground))
    }
}

struct CalendarHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarHeaderView(title: .constant(""),
                           daySelected: .constant(true),
                           jumpTodayHandler: {},
                           addStampHandler: {})
    }
}
