//
//  AwesomeSwiftUITests.swift
//  AwesomeSwiftUITests
//
//  Created by Matteo Crippa on 27/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import XCTest

class AwesomeSwiftUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    override func tearDown() {
        super.tearDown()
    }
    func testExample() {
    //    snapshot("0Lanch")
    }
}

