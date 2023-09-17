/*
 StampsView.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/08.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct StampsView<SVM: StampsViewModel>: View {
    @StateObject var viewModel: SVM
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Header
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
                        Text(Image(systemName: "plus"))
                            .font(.title2)
                    }
                    .buttonStyle(.square)
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
                        stampCard(stamp)
                    }
                }
                .padding(24)
            }
        }
        .background(SCColor.appBackground)
        .sheet(
            isPresented: $viewModel.showingSheet,
            onDismiss: {
                viewModel.targetStamp = nil
            },
            content: {
                if let stamp = viewModel.targetStamp {
                    EditStampView(viewModel: EditStampViewModelImpl(
                        original: stamp,
                        updateStampHandler: { id, stamp in
                            return viewModel.updateStamp(id, stamp)
                        },
                        deleteStampHandler: { id in
                            viewModel.deleteStamp(id)
                        }
                    ))
                } else {
                    AddNewStampView(viewModel: AddNewStampViewModelImpl(
                        addStampHandler: { stamp in
                            return viewModel.addNewStamp(stamp)
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
                    Text(orderBy.label).tag(orderBy)
                }
            } label: {
                Text("sortBy")
            }
            Picker(selection: $viewModel.stampOrderIn) {
                ForEach(StampOrderIn.allCases) { orderIn in
                    Text(orderIn.label).tag(orderIn)
                }
            } label: {
                Text("sortIn")
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down")
        }
        .onChange(of: viewModel.stampOrderBy) { _ in
            viewModel.sortStamps()
        }
        .onChange(of: viewModel.stampOrderIn) { _ in
            viewModel.sortStamps()
        }
    }

    private func stampCard(_ stamp: Stamp) -> some View {
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
                .onTapGesture {
                    viewModel.targetStamp = stamp
                    viewModel.showingSheet = true
                }
            }
    }
}

struct StampsView_Previews: PreviewProvider {
    static var previews: some View {
        StampsView(viewModel: PreviewMock.StampsViewModelMock())
    }
}
