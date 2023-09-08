/*
 StampsView.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/08.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct StampsView: View {
    @StateObject var viewModel = StampsViewModel()
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)

    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns) {
                ForEach(viewModel.stamps) { stamp in
                    Text("")
                }
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
