/*
 XCUIApplication+Extensions.swift
 StampRecord

 Created by Takuto Nakamura on 2023/10/23.
*/

import XCTest

extension XCUIApplication {
    func coordinate(of element: XCUIElement) -> XCUICoordinate {
        let frame = element.frame
        let point = CGPoint(x: frame.midX, y: frame.midY)
        let normalized = coordinate(withNormalizedOffset: .zero)
        return normalized.withOffset(CGVector(dx: point.x, dy: point.y))
    }
}
