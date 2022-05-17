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

    //TODO: only for using with UIKit at the moment
    func test_home_screen_enter_detail_and_see_navigation() throws {
        let app = XCUIApplication()
        app.launch()
        
        let curryGardenCell = app.tables.cells["Curry Garden"]
        curryGardenCell.tap()
        XCTAssert(app.staticTexts["Curry Garden"].firstMatch.label.contains("Curry Garden"))        
    }
    
}
