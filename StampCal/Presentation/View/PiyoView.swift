/*
 PiyoView.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/28.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct PiyoView: View {
    @State private var selection : Int = 0

    var body: some View {
        VStack {
            TabView(selection: $selection) {
                Text("View 01").background(Color.red).tag(0)
                Text("View 02").background(Color.blue).tag(1)
                Text("View 03").background(Color.yellow).tag(2)
            }
            .tabViewStyle(PageTabViewStyle())
            HStack {
                Button {
                    withAnimation {
                        selection = 0
                    }
                } label: {
                    Text("赤のViewへ").foregroundColor(.red)
                }
                Button {
                    withAnimation {
                        selection = 1
                    }
                } label: {
                    Text("青のViewへ").foregroundColor(.blue)
                }
                Button {
                    withAnimation {
                        selection = 2
                    }
                } label: {
                    Text("黄のViewへ").foregroundColor(.yellow)
                }
            }
        }
    }
}

struct PiyoView_Previews: PreviewProvider {
    static var previews: some View {
        PiyoView()
    }
}
