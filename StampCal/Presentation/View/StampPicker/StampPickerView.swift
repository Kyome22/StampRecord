/*
 StampPickerView.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/23.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct StampPickerView: View {
    @State var stamps: [Stamp]
    @State var stampOrderBy: StampOrderBy = .createdDate
    @State var stampOrderIn: StampOrderIn = .ascending
    let selectStampHandler: (Stamp) -> Void
    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 8), count: 3)
    let cellWidth: CGFloat = 84

    init(stamps: [Stamp], selectStampHandler: @escaping (Stamp) -> Void) {
        _stamps = State(initialValue: stamps)
        self.selectStampHandler = selectStampHandler
        sortStamps()
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Picker(selection: $stampOrderBy) {
                    ForEach(StampOrderBy.allCases) { orderBy in
                        orderBy.image.tag(orderBy)
                    }
                } label: {
                    Text("sortBy")
                }
                .pickerStyle(.segmented)
                Picker(selection: $stampOrderIn) {
                    ForEach(StampOrderIn.allCases) { orderIn in
                        orderIn.image.tag(orderIn)
                    }
                } label: {
                    Text("sortIn")
                }
                .pickerStyle(.segmented)
            }
            .padding(8)
            .onChange(of: stampOrderBy) { _ in
                sortStamps()
            }
            .onChange(of: stampOrderIn) { _ in
                sortStamps()
            }
            Divider()
                .overlay(Color(.cellBorder))
            ScrollView(.vertical, showsIndicators: true) {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(stamps) { stamp in
                        Button {
                            selectStampHandler(stamp)
                        } label: {
                            VStack(spacing: 4) {
                                Text(stamp.emoji)
                                    .font(.system(size: 40))
                                Text(stamp.summary)
                                    .font(.system(size: 20))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.05)
                                    .truncationMode(.tail)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .aspectRatio(1, contentMode: .fill)
                            .padding(4)
                        }
                        .buttonStyle(.cell)
                    }
                }
                .padding(8)
            }
            .frame(height: (cellWidth * 3.5) + (8 * 4))
            .background(Color(.appBackground))
        }
        .frame(width: (cellWidth * 3) + (8 * 4))
    }

    func sortStamps() {
        switch (stampOrderBy, stampOrderIn) {
        case (.createdDate, .ascending):
            stamps.sort { $0.createdDate < $1.createdDate }
        case (.createdDate, .descending):
            stamps.sort { $0.createdDate > $1.createdDate }
        case (.summary, .ascending):
            stamps.sort { $0.summary < $1.summary }
        case (.summary, .descending):
            stamps.sort { $0.summary > $1.summary }
        }
    }
}

struct StampPickerView_Previews: PreviewProvider {
    static var previews: some View {
        StampPickerView(stamps: [], selectStampHandler: { _ in })
    }
}
