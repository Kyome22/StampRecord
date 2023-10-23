/*
 StampsViewUITests.swift
 StampRecordUITests

 Created by Takuto Nakamura on 2023/10/18.
*/

import XCTest

final class StampsViewUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        app.launchEnvironment = ["EXEC_UITEST": "true"]
        app.launch()
    }

    override func tearDown() {
        app.terminate()
    }

    func test_addNewStamp() throws {
        app.buttons["Tab_Stamps"].tap()

        app.buttons["StampsView_PlusButton"].tap()
        app.buttons["AddNewStamp_EmojiButton"]
            .wait(until: \.exists)
            .wait(until: \.isHittable)
            .tap()
        app.popovers.collectionViews.buttons["😀"].tap()

        // Close Popover
        app.coordinate(of: app.staticTexts["Stamps"]).tap()

        let field = app.textFields["AddNewStamp_SummaryTextField"]
        field.tap()
        field.typeText("Smile\n")
        app.buttons["AddNewStamp_AddButton"].tap()
        let smileCard = app.buttons["StampsView_Card_Smile"].wait(until: \.exists)
        XCTAssertTrue(smileCard.exists)
    }

    func test_editStamp() throws {
        app.buttons["Tab_Stamps"].tap()

        app.buttons["StampsView_PlusButton"].tap()
        app.buttons["AddNewStamp_EmojiButton"]
            .wait(until: \.exists)
            .wait(until: \.isHittable)
            .tap()
        app.popovers.collectionViews.buttons["😀"].tap()

        // Close Popover
        let coordinate = app.coordinate(of: app.staticTexts["Stamps"])
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
    }

    func test_deleteStamp() throws {
        app.buttons["Tab_Stamps"].tap()

        app.buttons["StampsView_PlusButton"].tap()
        app.buttons["AddNewStamp_EmojiButton"]
            .wait(until: \.exists)
            .wait(until: \.isHittable)
            .tap()
        app.popovers.collectionViews.buttons["😀"].tap()

        // Close Popover
        let coordinate = app.coordinate(of: app.staticTexts["Stamps"])
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
    }
}
