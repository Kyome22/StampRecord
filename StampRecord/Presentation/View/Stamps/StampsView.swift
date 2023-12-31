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
    let summaryFont: Font

    init(
        viewModel: @autoclosure @escaping () -> SVM,
        device: Device
    ) {
        _viewModel = StateObject(wrappedValue: viewModel())
        columns = Array(
            repeating: .init(.flexible(), spacing: 16),
            count: device.columnCount
        )
        summaryFont = device.summaryFont
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
                        Image(.stampPlus)
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
                    .foregroundStyle(Color.emptyText)
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
                    EditStampView(viewModel: SVM.EVM(
                        original: stamp,
                        updateStampHandler: { stamp, emoji, summary in
                            try viewModel.updateStamp(stamp, emoji, summary)
                        },
                        deleteStampHandler: { stamp in
                            try viewModel.deleteStamp(stamp)
                        }
                    ))
                } else {
                    AddNewStampView(viewModel: SVM.AVM(
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
                .font(.title2)
        }
        .onChangeWithMigration(of: viewModel.stampOrderBy) {
            viewModel.sortStamps()
        }
        .onChangeWithMigration(of: viewModel.stampOrderIn) {
            viewModel.sortStamps()
        }
    }

    private func stampCard(_ stamp: Stamp) -> some View {
        Button {
            viewModel.selectedStamp = stamp
            viewModel.showingSheet = true
        } label: {
            VStack(spacing: 0) {
                Text(stamp.emoji)
                    .font(.system(size: 100))
                    .minimumScaleFactor(0.01)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .aspectRatio(1.66, contentMode: .fill)
                Divider()
                    .overlay(Color.cellBorder)
                    .padding(.horizontal, 8)
                Text(stamp.summary)
                    .font(summaryFont)
                    .lineLimit(1)
                    .minimumScaleFactor(0.05)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(4)
            }
            .aspectRatio(1, contentMode: .fill)
        }
        .buttonStyle(.cell)
        .accessibilityIdentifier("StampsView_Card_\(stamp.summary)")
        .shadow(color: Color.shadow, radius: 3, x: 0, y: 3)
    }
}

#Preview {
    StampsView(viewModel: PreviewMock.StampsViewModelMock(),
               device: .default)
}
