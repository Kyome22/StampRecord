/*
 EditStampView.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/13.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI
import EmojiPalette

struct EditStampView<EVM: EditStampViewModel>: View {
    @Environment(\.dismiss) var dismiss
    @FocusState var focusedField: FocusedField?
    @StateObject var viewModel: EVM

    var body: some View {
        VStack(spacing: 0) {
            HeaderHStack {
                Button("cancel") {
                    dismiss()
                }
                Text("editStamp")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                Button("done") {
                    if viewModel.updateStamp() {
                        dismiss()
                    }
                }
                .disabled(viewModel.disabledDone)
                .alert(
                    "unableSaveStamp",
                    isPresented: $viewModel.showOverlappedError,
                    actions: {},
                    message: {
                        Text("overlappedErrorMessage")
                    }
                )
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color(.toolbarBackground))
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
                    .textFieldStyle(.summary)
                    .focused($focusedField, equals: .title)
                }
                Button(role: .destructive) {
                    viewModel.showDeleteConfirmation = true
                } label: {
                    Label {
                        Text("deleteStamp")
                    } icon: {
                        Image(.stampFillXmark)
                    }
                }
                .buttonStyle(.delete)
                .confirmationDialog(
                    "deleteMessage",
                    isPresented: $viewModel.showDeleteConfirmation,
                    titleVisibility: .visible,
                    actions: {
                        Button(role: .destructive) {
                            viewModel.deleteStamp()
                            dismiss()
                        } label: {
                            Text("deleteStamp")
                        }
                    }
                )
                Spacer()
            }
            .padding(24)
        }
        .background(Color(.cellBackground))
        .presentationDetents([.medium])
        .onTapGesture {
            focusedField = nil
        }
    }
}

#Preview {
    EditStampView(viewModel: PreviewMock.EditStampViewModelMock())
}
