/*
 DayCalendarUITests.swift
 StampRecord

 Created by Takuto Nakamura on 2023/10/23.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import XCTest

final class DayCalendarUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        app.launchEnvironment = ["EXEC_UITEST": "true"]
        app.launch()
    }

    override func tearDown() {
        app.terminate()
    }

    func test_put_stamp_and_remove_stamp() throws {
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

        app.buttons["Tab_DayCalendar"].tap()

        app.buttons["CalendarHeaderView_StampButton"].tap()
        app.popovers.scrollViews.buttons["StampPickerView_Smile"].tap()

        let stampCard = app.staticTexts["DayView_StampCard_Smile"]
            .wait(until: \.exists)
        XCTAssertTrue(stampCard.exists)

        stampCard
            .wait(until: \.isHittable)
            .press(forDuration: 2.0)

        app.buttons["DayView_RemoveButton_Smile"]
            .wait(until: \.exists)
            .wait(until: \.isHittable)
            .tap()

        XCTAssertFalse(stampCard.exists)
    }
}
