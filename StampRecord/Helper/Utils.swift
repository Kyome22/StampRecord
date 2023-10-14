/*
 Utils.swift
StampRecord

 Created by Takuto Nakamura on 2023/08/20.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

func logput(
    _ items: Any...,
    file: String = #file,
    line: Int = #line,
    function: String = #function
) {
#if DEBUG
    let fileName = URL(fileURLWithPath: file).lastPathComponent
    var array: [Any] = ["💫Log: \(fileName)", "Line:\(line)", function]
    array.append(contentsOf: items)
    Swift.print(array)
#endif
}

func printDay(of date: Date) {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    Swift.print(formatter.string(from: date))
}

let NOT_IMPLEMENTED = "not implemented"
struct PreviewMock {}
