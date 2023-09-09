/*
 StampsView.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/08.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct StampsView: View {
    @StateObject var viewModel = StampsViewModel()
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 0) {
                ZStack {
                    HStack {
                        Spacer()
                        Button {
                            viewModel.addStamp()
                        } label: {
                            Image(systemName: "plus")
                                .font(.title2)
                        }
                    }
                    Text("stamps")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                Divider()
            }
            .background(SCColor.toolbarBackground)
            // Body
            ScrollView(.vertical) {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.stamps) { stamp in
                        RoundedRectangle(cornerRadius: 8)
                            .aspectRatio(1, contentMode: .fill)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(SCColor.cellBackground)
                            .shadow(color: SCColor.shadow, radius: 3, x: 0, y: 3)
                            .overlay {
                                VStack(spacing: 0) {
                                    Text(String(stamp.emoji))
                                        .font(.largeTitle)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                        .background(SCColor.cellHighlightWeek)
                                    Text(stamp.summary)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                        .padding(4)
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                    }
                }
                .padding(24)
            }
        }
        .background(SCColor.appBackground)
    }
}

struct StampsView_Previews: PreviewProvider {
    static var previews: some View {
        StampsView()
    }
}
