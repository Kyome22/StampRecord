/*
 AddNewStampView.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/10.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI
import EmojiPalette

struct AddNewStampView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = AddNewStampViewModel()

    var body: some View {
        VStack(spacing: 0) {
            // Header
            ZStack {
                HStack {
                    Button("cancel") {
                        dismiss()
                    }
                    Spacer()
                    Button("add") {

                    }
                    .disabled(true)
                }
                Text("newStamp")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(SCColor.toolbarBackground)
            VStack(spacing: 24) {
                Button {
                    viewModel.showEmojiPicker = true
                } label: {
                    Text(viewModel.emoji)
                }
                .buttonStyle(
                    SelectEmojiButtonStyle(isPresented: $viewModel.showEmojiPicker) {
                        EmojiPaletteView()
                    }
                )
                VStack(alignment: .leading, spacing: 16) {
                    Text("summary")
                        .font(.callout)
                    TextField("todo", text: $viewModel.summary)
                        .textFieldStyle(.roundedBorder)
                        .textContentType(.telephoneNumber)
                }
                Spacer()
            }
            .padding(24)
        }
        .background(SCColor.cellBackground)
        .presentationDetents([.medium])
    }
}

struct AddNewStampView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewStampView()
    }
}
