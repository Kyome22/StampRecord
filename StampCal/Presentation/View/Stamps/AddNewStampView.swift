/*
 AddNewStampView.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/10.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI
import EmojiPalette

struct AddNewStampView<AVM: AddNewStampViewModel>: View {
    @Environment(\.dismiss) var dismiss
    @FocusState var focusedField: FocusedField?
    @StateObject var viewModel: AVM

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HeaderHStack {
                Button("cancel") {
                    dismiss()
                }
                Text("newStamp")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                Button("add") {
                    if viewModel.addNewStamp() {
                        dismiss()
                    }
                }
                .disabled(viewModel.emoji.isEmpty || viewModel.summary.isEmpty)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color(.toolbarBackground))
            // Body
            VStack(spacing: 24) {
                Button {
                    viewModel.showEmojiPicker = true
                } label: {
                    Text(viewModel.emoji)
                }
                .buttonStyle(SelectEmojiButtonStyle(transform: { label in
                    label.emojiPalette(selectedEmoji: $viewModel.emoji,
                                       isPresented: $viewModel.showEmojiPicker)
                }))
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
                Spacer()
            }
            .padding(24)
        }
        .background(Color(.cellBackground))
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

#Preview {
    AddNewStampView(viewModel: PreviewMock.AddNewStampViewModelMock())
}
