/*
 StampsView.swift
StampRecord

 Created by Takuto Nakamura on 2023/09/08.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct StampsView<SVM: StampsViewModel>: View {
    @StateObject var viewModel: SVM
    let columns: [GridItem]

    init(
        viewModel: @autoclosure @escaping () -> SVM,
        isPhone: Bool
    ) {
        _viewModel = StateObject(wrappedValue: viewModel())
        self.columns = Array(repeating: .init(.flexible(), spacing: 16), count: isPhone ? 3 : 5)
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HeaderHStack {
                    sortMenu
                    Text("stamps")
                        .font(.body)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                    Button {
                        viewModel.showingSheet = true
                    } label: {
                        Text(Image(.stampPlus))
                            .font(.title2)
                    }
                    .buttonStyle(.square)
                    .accessibilityIdentifier("StampsView_PlusButton")
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                Divider()
            }
            .background(Color.toolbarBackground)
            if viewModel.stamps.isEmpty {
                Text("noStamps")
                    .font(.title3)
                    .foregroundColor(Color.emptyText)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView(.vertical) {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.stamps) { stamp in
                            stampCard(stamp)
                        }
                    }
                    .padding(24)
                }
            }
        }
        .background(Color.appBackground)
        .sheet(
            isPresented: $viewModel.showingSheet,
            onDismiss: {
                viewModel.selectedStamp = nil
            },
            content: {
                if let stamp = viewModel.selectedStamp {
                    EditStampView(viewModel: EditStampViewModelImpl(
                        original: stamp,
                        updateStampHandler: { stamp, emoji, summary in
                            try viewModel.updateStamp(stamp, emoji, summary)
                        },
                        deleteStampHandler: { stamp in
                            try viewModel.deleteStamp(stamp)
                        }
                    ))
                } else {
                    AddNewStampView(viewModel: AddNewStampViewModelImpl(
                        addStampHandler: { emoji, summary in
                            try viewModel.addNewStamp(emoji, summary)
                        }
                    ))
                }
            }
        )
    }

    private var sortMenu: some View {
        Menu {
            Picker(selection: $viewModel.stampOrderBy) {
                ForEach(StampOrderBy.allCases) { orderBy in
                    Label {
                        Text(orderBy.label)
                    } icon: {
                        orderBy.image
                    }
                    .tag(orderBy)
                }
            } label: {
                Text("sortBy")
            }
            Picker(selection: $viewModel.stampOrderIn) {
                ForEach(StampOrderIn.allCases) { orderIn in
                    Label {
                        Text(orderIn.label)
                    } icon: {
                        orderIn.image
                    }
                    .tag(orderIn)
                }
            } label: {
                Text("sortIn")
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down")
        }
        .onChange(of: viewModel.stampOrderBy) { _, _ in
            viewModel.sortStamps()
        }
        .onChange(of: viewModel.stampOrderIn) { _, _ in
            viewModel.sortStamps()
        }
    }

    private func stampCard(_ stamp: Stamp) -> some View {
        Button {
            viewModel.selectedStamp = stamp
            viewModel.showingSheet = true
        } label: {
            VStack(spacing: 0) {
                Text(String(stamp.emoji))
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.01)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .aspectRatio(1.66, contentMode: .fill)
                Divider()
                    .overlay(Color.cellBorder)
                    .padding(.horizontal, 8)
                Text(stamp.summary)
                    .font(.caption)
                    .lineLimit(1)
                    .minimumScaleFactor(0.05)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(4)
            }
            .aspectRatio(1, contentMode: .fill)
        }
        .buttonStyle(.cell)
        .shadow(color: Color.shadow, radius: 3, x: 0, y: 3)
        .accessibilityIdentifier("StampsView_Card_\(stamp.summary)")
    }
}

#Preview {
    StampsView(viewModel: PreviewMock.StampsViewModelMock(),
               isPhone: true)
}
