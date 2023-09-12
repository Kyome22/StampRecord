/*
 PagingHeaderView.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/08.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct PagingHeaderView: View {
    @Binding var title: String
    let pageBackwardHandler: () -> Void
    let pageForwardHandler: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HeaderHStack {
                Button {
                    pageBackwardHandler()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                Text(verbatim: title)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                Button {
                    pageForwardHandler()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            Divider()
        }
        .background(SCColor.toolbarBackground)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        PagingHeaderView(title: .constant(""),
                   pageBackwardHandler: {},
                   pageForwardHandler: {})
    }
}
