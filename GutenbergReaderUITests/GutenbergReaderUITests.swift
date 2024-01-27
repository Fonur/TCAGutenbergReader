//
//  GutenbergReaderUITests.swift
//  GutenbergReaderUITests
//
//  Created by Fikret Onur ÖZDİL on 26.01.2024.
//

import XCTest

final class GutenbergReaderUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    func testSettingsList() throws {
        XCUIApplication().tabBars["Tab Bar"].buttons["Settings"].tap()
    }

    func testSearchList() throws {
        XCUIApplication().tabBars["Tab Bar"].buttons["Search"].tap()
    }

    func testRoot() throws {
        XCUIApplication().tabBars["Tab Bar"].buttons["Home"].tap()
    }
}
