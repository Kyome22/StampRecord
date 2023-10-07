/*
 FontView.swift
 StampCal

 Created by Takuto Nakamura on 2023/10/01.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct FontView: View {
    let date1: Date
    let date2: Date
    let date3: Date

    init() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        date1 = formatter.date(from: "2023/10/1 0:22:22")!
        date2 = formatter.date(from: "2023/10/4 0:22:02")!
        date3 = formatter.date(from: "2023/9/1 0:02:22")!
    }

    var body: some View {
        VStack(spacing: 10) {
            Text("0")
                .font(.custom("RunningCat-Regular", size: 100)) // 87.333 109
                .fixedSize()
                .border(Color.red)
            cat(Date.now, 200)
            cat(date2, 200)
            cat(date3, 200)
        }
    }

    func cat(_ date: Date, _ size: CGFloat) -> some View {
        Group {
            Group {
                Text(date, style: .timer)
                    .font(.custom("RunningCat-Regular", size: size))
                    .lineLimit(1)
                    .truncationMode(.head)
                    .frame(width: 3.5 * size)
            }
            .fixedSize()
        }
        .frame(width: 0.87 * size,
               height: 0.55 * size,
               alignment: .trailingFirstTextBaseline)
        .clipped()
    }
}

struct FontView_Previews: PreviewProvider {
    static var previews: some View {
        FontView()
    }
}
