/*
 HStackedStamps.swift
StampRecord

 Created by Takuto Nakamura on 2023/10/10.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct HStackedStamps: View {
    @State var showErrorAlert: Bool = false
    @State var srError: SRError? = nil
    let stamps: [Stamp]
    let removeStampHandler: (Int) throws -> Void

    var body: some View {
        OverlappingHStack(alignment: .leading, spacing: 4) {
            ForEach(stamps.indices, id: \.self) { index in
                Text(stamps[index].emoji)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.01)
                    .padding(4)
            }
        }
        .padding(4)
        .contextMenu {
            Section("removeStamp") {
                ForEach(stamps.indices, id: \.self) { index in
                    Button(role: .destructive) {
                        do {
                            try removeStampHandler(index)
                        } catch let error as SRError {
                            srError = error
                            showErrorAlert = true
                        } catch {}
                    } label: {
                        Label {
                            Text(verbatim: "\(stamps[index].emoji) \(stamps[index].summary)")
                        } icon: {
                            Image(.stampFillMinus)
                        }
                    }
                }
            }
        }
        .alertSRError(isPresented: $showErrorAlert, srError: srError)
    }
}

#Preview {
    HStackedStamps(stamps: [], removeStampHandler: { _ in })
}
