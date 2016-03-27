//
//  CategoryModelTests.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 27/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import XCTest
@testable import AwesomeSwift

class CategoryModelTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testInit_ShouldTakeNoParams() {
        let cat = CategoryModel()
        XCTAssertNotNil(cat, "cat should be not nil")
    }

    func testInit_ShouldTakeName() {
        let testName = "test"
        let cat = CategoryModel()
        cat.name = testName
        XCTAssertEqual(cat.name, testName, "cat name is test")
    }

    func testCatWithSameName_ShouldBeSame() {
        let testName = "cat"
        let firstCat = CategoryModel()
        firstCat.name = testName
        let secondCat = CategoryModel()
        secondCat.name = testName
        XCTAssertEqual(firstCat, secondCat, "should be the same cat")
    }

}
