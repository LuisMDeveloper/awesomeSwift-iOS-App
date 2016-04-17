//
//  AwesomeSwiftUITests.swift
//  AwesomeSwiftUITests
//
//  Created by Matteo Crippa on 27/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import XCTest

class AwesomeSwiftUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        setupSnapshot(app)
        app.launch()
    }
    override func tearDown() {
        super.tearDown()
    }
    func testExample() {
    snapshot("0Lanch")

        let tablesQuery = app.tables
        tablesQuery.staticTexts["Misc"].tap()
        snapshot("1Repos")

        tablesQuery.cells.containingType(.StaticText, identifier:"sbconstants").buttons["favoriteDeselect"].tap()
        tablesQuery.cells.containingType(.StaticText, identifier:"swamp").buttons["favoriteDeselect"].tap()
        tablesQuery.cells.containingType(.StaticText, identifier:"SwiftGen").buttons["favoriteDeselect"].tap()
        tablesQuery.cells.containingType(.StaticText, identifier:"SwiftHub").buttons["favoriteDeselect"].tap()

        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Favorites"].tap()
        snapshot("2Fav")

        tabBarsQuery.buttons["Credits"].tap()
        snapshot("3Credits")


    }

}
