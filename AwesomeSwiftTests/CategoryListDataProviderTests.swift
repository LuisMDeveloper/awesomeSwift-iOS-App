//
//  CategoryListDataProviderTests.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 28/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import XCTest
@testable import AwesomeSwift
/*
class CategoryListDataProviderTests: XCTestCase {

    var sut: CategoryListDataProvider!
    var tableView: UITableView!
    var controller: CategoryListViewController!

    override func setUp() {
        super.setUp()
        sut = CategoryListDataProvider()
        sut.categoryManager = CategoryManager()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // swiftlint:disable force_cast
        controller = storyboard.instantiateViewControllerWithIdentifier("CategoryListViewController") as! CategoryListViewController
        _ = controller.view

        tableView = controller.tableView
        tableView.dataSource = sut
    }

    override func tearDown() {
        super.tearDown()
    }

    func testNumberOfSections_IsOne() {
        let numberOfSections = tableView.numberOfSections
        XCTAssertEqual(numberOfSections, 1)
    }

    func testNumberRowsInSection_IsCatCount() {
        let firstCat = CategoryModel()
        firstCat.name = "one"
        sut.categoryManager?.addCat(firstCat)
        XCTAssertEqual(tableView.numberOfRowsInSection(0), 1)
        let secondCat = CategoryModel()
        secondCat.name = "two"
        sut.categoryManager?.addCat(secondCat)
        tableView.reloadData()
        XCTAssertEqual(tableView.numberOfRowsInSection(0), 2)
    }

    func testCellForRow_ReturnsCategoryCell() {
        let firstCat = CategoryModel()
        firstCat.name = "one"
        sut.categoryManager?.addCat(firstCat)
        tableView.reloadData()

        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))

        XCTAssertTrue(cell is CategoryCell)
    }

    func testCellForRow_DequeuesCell() {
        let mockTableView = MockTableView()

        mockTableView.dataSource = sut

        mockTableView.registerClass(CategoryCell.self, forCellReuseIdentifier: "CategoryCell")

        let firstCat = CategoryModel()
        firstCat.name = "one"
        sut.categoryManager?.addCat(firstCat)
        mockTableView.reloadData()

        _ = mockTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))

        XCTAssertTrue(mockTableView.cellGotDequeued)
    }
    
    func testConfigCell_GetsCalledInCellForRow() {

        let mockTableView = MockTableView()

        mockTableView.dataSource = sut

        mockTableView.registerClass(MockCategoryCell.self, forCellReuseIdentifier: "CategoryCell")

        let firstCat = CategoryModel()
        firstCat.name = "one"
        sut.categoryManager?.addCat(firstCat)
        mockTableView.reloadData()

        // swiftlint:disable force_cast
        let cell = mockTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! MockCategoryCell

        XCTAssertEqual(cell.category, firstCat)
    }

}

extension CategoryListDataProviderTests {
    class MockTableView: UITableView {
        var cellGotDequeued = false

        override func dequeueReusableCellWithIdentifier(identifier: String, forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            cellGotDequeued = true
            return super.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        }
    }
    
    class MockCategoryCell: CategoryCell {
        var category: CategoryModel?
        
        override func configCellWithCategory(cat: CategoryModel) {
            category = cat
        }
    }

}
*/