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
    let stamps: [LoggedStamp]
    let removeStampHandler: (LoggedStamp) throws -> Void

    var body: some View {
        OverlappingHStack(alignment: .leading, spacing: 4) {
            ForEach(stamps) { stamp in
                if stamp.isIncluded {
                    Text(stamp.emoji)
                        .font(.system(size: 200))
                        .minimumScaleFactor(0.01)
                        .padding(4)
                }
            }
        }
        .padding(4)
        .contextMenu {
            Section("removeStamp") {
                ForEach(stamps) { stamp in
                    if stamp.isIncluded {
                        Button(role: .destructive) {
                            do {
                                try removeStampHandler(stamp)
                            } catch let error as SRError {
                                srError = error
                                showErrorAlert = true
                            } catch {}
                        } label: {
                            Label {
                                Text(verbatim: "\(stamp.emoji) \(stamp.summary)")
                            } icon: {
                                Image(.stampFillMinus)
                            }
                        }
                        .accessibilityIdentifier("HStackedStamps_RemoveButton_\(stamp.summary)")
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
