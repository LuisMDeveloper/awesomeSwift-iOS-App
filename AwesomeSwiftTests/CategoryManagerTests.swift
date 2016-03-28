//
//  CategoryManagerTests.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 27/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import XCTest
@testable import AwesomeSwift

class CategoryManagerTests: XCTestCase {

    var sut: CategoryManager!

    override func setUp() {
        super.setUp()
        sut = CategoryManager()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testCategoryCount_Initially_ShouldBeZero() {
        XCTAssertEqual(sut.catCount, 0, "Initially count count should be 0")
    }

    func testCategoryCount_AfterAddingOneItem_IsOne() {
        let cat = CategoryModel()
        sut.addCat(cat)
        XCTAssertEqual(sut.catCount, 1, "Adding one cat, catCount should be 1")
    }

    func testCategoryAtIndex_ShouldReturnPreviouslyAddedItem() {
        let cat = CategoryModel()
        cat.name = "test"
        sut.addCat(cat)

        let returnedCat = sut.catAtIndex(0)

        XCTAssertEqual(cat.name, returnedCat!.name, "Should be named the same")
    }

    func testCategoryCount_AfterRemovingOneItem_IsZero() {
        let firstCat = CategoryModel()
        firstCat.name = "test"
        sut.addCat(firstCat)

        sut.removeCatAtIndex(0)

        XCTAssertEqual(sut.catCount, 0, "Should be 0 cats")
    }

    func testCategoryCount_AfterRemovingAllItems_IsZero() {
        let firstCat = CategoryModel()
        firstCat.name = "test"
        sut.addCat(firstCat)
        let secondCat = CategoryModel()
        secondCat.name = "test"
        sut.addCat(secondCat)

        sut.removeAllCats()

        XCTAssertEqual(sut.catCount, 0, "Should be 0 cats")
    }

    func testCategoryUniquenessCount_AddingRepoTwice_ShouldBeOne() {
        let firstCat = CategoryModel()
        firstCat.name = "test"
        sut.addCat(firstCat)
        let secondCat = CategoryModel()
        secondCat.name = "test"
        sut.addCat(secondCat)

        XCTAssertEqual(sut.catCount, 1, "Should be 1")
    }

    func testCategoryExtractOutOfRange_ShouldExtractNil() {
        let firstCat = CategoryModel()
        firstCat.name = "test"
        sut.addCat(firstCat)

        let returnedItem = sut.catAtIndex(1)

        XCTAssertNil(returnedItem)
    }

    func testCategoryRemoveOutOfRange_ShouldNotExtract() {
        let firstCat = CategoryModel()
        firstCat.name = "test"
        sut.addCat(firstCat)

        sut.removeCatAtIndex(1)

        XCTAssertEqual(sut.catCount, 1, "Should be 1 repo")
    }

}
