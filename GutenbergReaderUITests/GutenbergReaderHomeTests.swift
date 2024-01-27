//
//  GutenbergReaderHomeTests.swift
//  GutenbergReaderUITests
//
//  Created by Fikret Onur ÖZDİL on 27.01.2024.
//

import XCTest

@MainActor
final class GutenbergReaderHomeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDownloadsList() throws {
        XCUIApplication().navigationBars["Recently Added"]/*@START_MENU_TOKEN@*/.buttons["Downloads"]/*[[".otherElements[\"Recently Added\"].buttons[\"Downloads\"]",".buttons[\"Downloads\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        snapshot("Downloads")
    }

    func testRecentlyAddedList() throws {
        XCUIApplication().navigationBars["Downloads"]/*@START_MENU_TOKEN@*/.buttons["Recently Added"]/*[[".otherElements[\"Recently Added\"].buttons[\"Recently Added\"]",".buttons[\"Recently Added\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCUIApplication().navigationBars["Recently Added"]/*@START_MENU_TOKEN@*/.buttons["Downloads"]/*[[".otherElements[\"Recently Added\"].buttons[\"Downloads\"]",".buttons[\"Downloads\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        snapshot("RecentlyAdded")
    }
}
