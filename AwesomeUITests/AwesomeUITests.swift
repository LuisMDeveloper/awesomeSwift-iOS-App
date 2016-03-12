//
//  AwesomeUITests.swift
//  AwesomeUITests
//
//  Created by Matteo Crippa on 07/02/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import XCTest

class AwesomeUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        
        let app = XCUIApplication()
        setupSnapshot(app)
        
        app.launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        snapshot("01Repository")
        
        let app = XCUIApplication()
        let searchButton = app.navigationBars["awesomeswift.RepoView"].buttons["Search"]
        searchButton.tap()
        let searchInLibsSearchField = app.searchFields["search in libs"]
        searchInLibsSearchField.tap()
        searchInLibsSearchField.typeText("swift")

        snapshot("02Filtered")

    }
    
}
