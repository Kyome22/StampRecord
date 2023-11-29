/*
 FlexibleStackedStamps.swift
 StampRecord

 Created by Takuto Nakamura on 2023/11/28.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct FlexibleStackedStamps: View {
    @State var showErrorAlert: Bool = false
    @State var srError: SRError? = nil
    let stamps: [Stamp]
    let removeStampHandler: (Int) throws -> Void

    var body: some View {
        FlexibleHStack(spacing: 4) {
            ForEach(stamps.indices, id: \.self) { index in
                if stamps[index].isIncluded {
                    Text(stamps[index].emoji)
                        .font(.system(size: 200))
                        .minimumScaleFactor(0.01)
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .padding(4)
        .contextMenu {
            Section("removeStamp") {
                ForEach(stamps.indices, id: \.self) { index in
                    if stamps[index].isIncluded {
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
                        .accessibilityIdentifier("FlexibleStackedStamps_RemoveButton_\(stamps[index].summary)")
                    }
                }
            }
        }
        .alertSRError(isPresented: $showErrorAlert, srError: srError)
    }
}

#Preview {
    FlexibleStackedStamps(stamps: [], removeStampHandler: { _ in })
}
