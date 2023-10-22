//
//  StampRecordUITests.swift
//  StampRecordUITests
//
//  Created by Takuto Nakamura on 2023/10/18.
//

import XCTest

final class StampRecordUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func test_addNewStamp() throws {
        let app = XCUIApplication()
        app.launchEnvironment = ["EXEC_UITEST": "true"]
        app.launch()

        app.buttons["Tab_Stamps"].tap()
        app.buttons["StampsView_PlusButton"].tap()
        app.buttons["AddNewStamp_EmojiButton"]
            .wait(until: \.exists)
            .wait(until: \.isHittable)
            .tap()
        app.popovers.collectionViews.buttons["😀"].tap()

        // Close Popover
        let tabTitleFrame = app.staticTexts["Stamps"].frame
        let point = CGPoint(x: tabTitleFrame.midX, y: tabTitleFrame.midY)
        let normalized = app.coordinate(withNormalizedOffset: .zero)
        let coordinate = normalized.withOffset(CGVector(dx: point.x, dy: point.y))
        coordinate.tap()

        let field = app.textFields["AddNewStamp_SummaryTextField"]
        field.tap()
        field.typeText("Smile\n")
        app.buttons["AddNewStamp_AddButton"].tap()
        let smileCard = app.buttons["StampsView_Card_Smile"].wait(until: \.exists)
        XCTAssertTrue(smileCard.exists)
        app.terminate()
    }

    func test_editStamp() throws {
        let app = XCUIApplication()
        app.launchEnvironment = ["EXEC_UITEST": "true"]
        app.launch()

        app.buttons["Tab_Stamps"].tap()

        // Add
        app.buttons["StampsView_PlusButton"].tap()
        app.buttons["AddNewStamp_EmojiButton"]
            .wait(until: \.exists)
            .wait(until: \.isHittable)
            .tap()
        app.popovers.collectionViews.buttons["😀"].tap()

        // Close Popover
        let tabTitleFrame = app.staticTexts["Stamps"].frame
        let point = CGPoint(x: tabTitleFrame.midX, y: tabTitleFrame.midY)
        let normalized = app.coordinate(withNormalizedOffset: .zero)
        let coordinate = normalized.withOffset(CGVector(dx: point.x, dy: point.y))
        coordinate.tap()

        let field1 = app.textFields["AddNewStamp_SummaryTextField"]
        field1.tap()
        field1.typeText("Smile\n")
        app.buttons["AddNewStamp_AddButton"].tap()

        app.buttons["StampsView_Card_Smile"]
            .wait(until: \.exists)
            .wait(until: \.isHittable)
            .tap()

        // Edit
        app.buttons["EditStamp_EmojiButton"]
            .wait(until: \.exists)
            .wait(until: \.isHittable)
            .tap()
        app.popovers.collectionViews.buttons["😇"].tap()

        // Close Popover
        coordinate.tap()

        let field2 = app.textFields["EditStamp_SummaryTextField"]
        field2.tap()
        field2.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: 5))
        field2.typeText("Angel\n")
        app.buttons["EditStamp_DoneButton"].tap()

        let angelCard = app.buttons["StampsView_Card_Angel"].wait(until: \.exists)
        XCTAssertTrue(angelCard.exists)
        app.terminate()
    }

    func test_deleteStamp() throws {
        let app = XCUIApplication()
        app.launchEnvironment = ["EXEC_UITEST": "true"]
        app.launch()

        app.buttons["Tab_Stamps"].tap()

        // Add
        app.buttons["StampsView_PlusButton"].tap()
        app.buttons["AddNewStamp_EmojiButton"]
            .wait(until: \.exists)
            .wait(until: \.isHittable)
            .tap()
        app.popovers.collectionViews.buttons["😀"].tap()

        // Close Popover
        let tabTitleFrame = app.staticTexts["Stamps"].frame
        let point = CGPoint(x: tabTitleFrame.midX, y: tabTitleFrame.midY)
        let normalized = app.coordinate(withNormalizedOffset: .zero)
        let coordinate = normalized.withOffset(CGVector(dx: point.x, dy: point.y))
        coordinate.tap()

        let field1 = app.textFields["AddNewStamp_SummaryTextField"]
        field1.tap()
        field1.typeText("Smile\n")
        app.buttons["AddNewStamp_AddButton"].tap()

        app.buttons["StampsView_Card_Smile"]
            .wait(until: \.exists)
            .wait(until: \.isHittable)
            .tap()

        // Delete
        app.buttons["EditStamp_DeleteButton"].tap()
        app.buttons["EditStamp_ConfirmButton"]
            .wait(until: \.exists)
            .wait(until: \.isHittable)
            .tap()
        let smileCard = app.buttons["StampsView_Card_Smile"]
            .wait(until: \.exists, matches: false)
        XCTAssertFalse(smileCard.exists)
        app.terminate()
    }
}
