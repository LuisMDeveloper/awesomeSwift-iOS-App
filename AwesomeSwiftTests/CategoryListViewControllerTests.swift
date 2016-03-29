//
//  CategoryListViewControllerTests.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 28/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import XCTest
@testable import AwesomeSwift

class CategoryListViewControllerTests: XCTestCase {

    var sut: CategoryListViewController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // swiftlint:disable force_cast
        sut = storyboard.instantiateViewControllerWithIdentifier("CategoryListViewController") as! CategoryListViewController
        _ = sut.view
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_TableViewIsNotNilAfterViewDidLoad() {
        XCTAssertNotNil(sut.tableView)
    }

    func testViewDidLoad_ShouldSetTableViewDataSource() {
        XCTAssertNotNil(sut.tableView.dataSource)
        XCTAssertTrue(sut.tableView.dataSource is CategoryListDataProvider)
    }

    func testViewDidLoad_ShouldSetTableViewDelegate() {
        XCTAssertNotNil(sut.tableView.delegate)
        XCTAssertTrue(sut.tableView.delegate is CategoryListDataProvider)
    }

    func testViewDidLoad_ShouldSetDelegateAndDataSourceToTheSameObject() {
        XCTAssertEqual(sut.tableView.dataSource as? CategoryListDataProvider, sut.tableView.delegate as? CategoryListDataProvider)
    }
}
