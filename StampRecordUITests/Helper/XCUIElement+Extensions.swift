/*
 XCUIElement+Extensions.swift
 StampRecord

 Created by Takuto Nakamura on 2023/10/22.
*/

import XCTest

extension XCUIElement {
    @discardableResult
    func wait(
        until expression: @escaping (XCUIElement) -> Bool,
        timeout: TimeInterval = 5,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self {
        if expression(self) {
            return self
        }
        let predicate = NSPredicate { _, _ in
            expression(self)
        }
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: nil)
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        if result != .completed {
            XCTFail(
                message().isEmpty ? "expectation not matched after wating" : message(),
                file: file,
                line: line
            )
        }
        return self
    }

    @discardableResult
    func wait<Value: Equatable>(
        until keyPath: KeyPath<XCUIElement, Value>,
        matches match: Value,
        timeout: TimeInterval = 5,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self {
        return wait(
            until: { $0[keyPath: keyPath] == match },
            timeout: timeout,
            message: message(),
            file: file,
            line: line
        )
    }

    func wait(
        until keyPath: KeyPath<XCUIElement, Bool>,
        timeout: TimeInterval = 5,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self {
        return wait(
            until: keyPath,
            matches: true,
            timeout: timeout,
            message: message(),
            file: file,
            line: line
        )
    }
}
