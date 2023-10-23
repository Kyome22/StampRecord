/*
 WeekCalendarUITests.swift
 StampRecord

 Created by Takuto Nakamura on 2023/10/23.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import XCTest

final class WeekCalendarUITests: XCTestCase {
    let app = XCUIApplication()
    let dayText = Calendar.current.component(.day, from: Date.now).description

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

        app.buttons["Tab_WeekCalendar"].tap()

        app.staticTexts["HWDayView_DayText_\(dayText)"].tap()
        app.buttons["CalendarHeaderView_StampButton"].tap()
        app.popovers.scrollViews.buttons["StampPickerView_Smile"].tap()

        let stampCard = app.staticTexts["HWDayView_HStackedStamps_\(dayText)"]
            .firstMatch
        XCTAssertTrue(stampCard.exists)
        XCTAssertEqual(stampCard.label, "😀")

        stampCard
            .wait(until: \.isHittable)
            .press(forDuration: 2.0)

        app.buttons["HStackedStamps_RemoveButton_Smile"]
            .wait(until: \.exists)
            .wait(until: \.isHittable)
            .tap()

        XCTAssertFalse(stampCard.exists)
    }
}
