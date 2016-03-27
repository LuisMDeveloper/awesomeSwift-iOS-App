//
//  RepositoryTests.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 27/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import XCTest
@testable import AwesomeSwift

class RepositoryModelTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testInit_ShouldTakeNoParams() {
        let item = RepositoryModel()
        XCTAssertNotNil(item, "repo should not be nil")
    }

    func testInit_ShoudlTakeName() {
        let item = RepositoryModel()
        let testName = "test"

        item.name = testName
        
        XCTAssertEqual(item.name, testName, "repo shoud be named test")
    }

    func testInit_ShouldTakeNameAndDescription() {
        let item = RepositoryModel()
        let testName = "test"
        let testDescription = "test description"

        item.name = testName
        item.descr = testDescription

        XCTAssertEqual(item.descr, testDescription, "repo shoud be described as test description")
    }

    func testInit_ShouldTakeNameAndDescriptionAndCategory() {
        let item = RepositoryModel()

        let testName = "test"
        let testDescription = "test description"
        let testCategory = "test cat"

        item.name = testName
        item.descr = testDescription
        item.category = testCategory

        XCTAssertEqual(item.category, testCategory, "repo should be categorized as test cat")
    }

    func testInit_ShouldTakeNameAndDescriptionAndCategoryAndUrl() {
        let item = RepositoryModel()

        let testName = "test"
        let testDescription = "test description"
        let testCategory = "test cat"
        let testUrl = "test.url"

        item.name = testName
        item.descr = testDescription
        item.category = testCategory
        item.url = testUrl

        XCTAssertEqual(item.url, testUrl, "repo should have url set to test.url")
    }

    func testInit_ShouldTakeNameAndDescriptionAndCategoryAndUrlAndCreatedAt() {
        let item = RepositoryModel()

        let testName = "test"
        let testDescription = "test description"
        let testCategory = "test cat"
        let testUrl = "test.url"
        let createdAt = NSDate()

        item.name = testName
        item.descr = testDescription
        item.category = testCategory
        item.url = testUrl
        item.createdAt = createdAt

        XCTAssertEqual(item.createdAt, createdAt, "repo should have createdAt set to today")
    }

    func testWhenReposHaveDifferentNames_ShouldBeNotEqual() {
        let firstItem = RepositoryModel()
        firstItem.name = "first"

        let secondItem = RepositoryModel()
        secondItem.name = "second"

        XCTAssertNotEqual(firstItem, secondItem)
    }

}
