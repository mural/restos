//
//  restosUITests.swift
//  restosUITests
//
//  Created by Agustin Sgarlata on 5/13/22.
//

import XCTest
import SwiftUI
import ViewInspector //TODO: borrar sino se usa...

class restosUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        let curryGardenRating95Cell = app.tables.cells["Curry Garden, Rating: 9.5"]
        XCTAssert(curryGardenRating95Cell.label.contains("Curry Garden"))
        app.tables/*@START_MENU_TOKEN@*/.buttons["Curry Garden, Rating: 9.5"]/*[[".cells[\"Curry Garden, Rating: 9.5\"].buttons[\"Curry Garden, Rating: 9.5\"]",".buttons[\"Curry Garden, Rating: 9.5\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssert(app.navigationBars["_TtGC7SwiftUI19UIHosting"].buttons["Restos 🍽"].label.contains("Restos"))
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
