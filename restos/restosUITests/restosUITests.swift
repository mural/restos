//
//  restosUITests.swift
//  restosUITests
//
//  Created by Agustin Sgarlata on 5/13/22.
//

import XCTest
import SwiftUI

class restosUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func test_home_screen_enter_detail_and_see_navigation() throws {
        let app = XCUIApplication()
        app.launch()

        let useUIKit = !BundleUtils.getUIModeSwiftUIEnabled()
        
        if (useUIKit) {
            let curryGardenCell = app.tables.cells["Curry Garden"]
            curryGardenCell.tap()
            XCTAssert(app.staticTexts["Curry Garden"].firstMatch.label.contains("Curry Garden"))
        } else {
            let curryGardenRating95Cell = app.tables.cells["Curry Garden, Rating: 9.5"]
            XCTAssert(curryGardenRating95Cell.label.contains("Curry Garden"))
            app.tables/*@START_MENU_TOKEN@*/.buttons["Curry Garden, Rating: 9.5"]/*[[".cells[\"Curry Garden, Rating: 9.5\"].buttons[\"Curry Garden, Rating: 9.5\"]",".buttons[\"Curry Garden, Rating: 9.5\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            XCTAssert(app.staticTexts["Curry Garden"].firstMatch.label.contains("Curry Garden"))
        }
    }
    
}
