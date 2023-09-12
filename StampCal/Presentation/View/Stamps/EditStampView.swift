/*
 EditStampView.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/13.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI
import EmojiPalette

struct EditStampView: View {
    @Environment(\.dismiss) var dismiss
    @FocusState var focusedField: FocusedField?
    @StateObject var viewModel: EditStampViewModel

    init(viewModel: @autoclosure @escaping () -> EditStampViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HeaderHStack {
                Button("cancel") {
                    dismiss()
                }
                Text("editStamp")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                Button("done") {
                    if viewModel.doneEditStamp() {
                        dismiss()
                    }
                }
                .disabled(viewModel.emoji.isEmpty || viewModel.summary.isEmpty)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(SCColor.toolbarBackground)
            // Body
            VStack(spacing: 24) {
                Button {
                    viewModel.showEmojiPicker = true
                } label: {
                    Text(viewModel.emoji)
                }
                .buttonStyle(
                    SelectEmojiButtonStyle(isPresented: $viewModel.showEmojiPicker) {
                        EmojiPaletteView(selectedEmoji: $viewModel.emoji)
                    }
                )
                VStack(alignment: .leading, spacing: 16) {
                    Text("summary")
                        .font(.headline)
                    TextField(
                        "inputSummary",
                        text: Binding<String>(
                            get: { viewModel.summary },
                            set: { viewModel.summary = String($0.prefix(20)).trimmingCharacters(in: .whitespaces) }
                        )
                    )
                    .textFieldStyle(.roundedBorder)
                    .focused($focusedField, equals: .title)
                }
                Button {
                    viewModel.deleteStamp()
                    dismiss()
                } label: {
                    Text("delete")
                }
                Spacer()
            }
            .padding(24)
        }
        .background(SCColor.cellBackground)
        .presentationDetents([.medium])
        .onTapGesture {
            focusedField = nil
        }
        .alert(
            "unableAddStamp",
            isPresented: $viewModel.showOverlappedError,
            actions: {},
            message: {
                Text("overlappedErrorMessage")
            }
        )
    }
}

struct EditStampView_Previews: PreviewProvider {
    static var previews: some View {
        EditStampView(viewModel: EditStampViewModel(
            originalStamp: Stamp(emoji: "", summary: ""),
            doneEditStampHandler: { _ in true },
            deleteStampHandler: {}
        ))
    }
}
