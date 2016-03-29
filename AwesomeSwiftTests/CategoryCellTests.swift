//
//  CategoryCellTests.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 28/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import XCTest
@testable import AwesomeSwift

class CategoryCellTests: XCTestCase {

    var tableView: UITableView!

   /* override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // swiftlint:disable force_cast
        let controller = storyboard.instantiateViewControllerWithIdentifier("CategoryListViewController") as! CategoryListViewController
        _ = controller.view

        tableView = controller.tableView
        tableView.dataSource = FakeDataSource()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSUT_HasNameLabel() {
        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! CategoryCell

        XCTAssertNotNil(cell.textLabel)
    }

    func testConfigWithCategory_SetsName() {
        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! CategoryCell
        let firstCat = CategoryModel()
        firstCat.name = "test"
        cell.configCellWithCategory(firstCat)
        XCTAssertEqual(cell.textLabel?.text, "test")
    }*/

}

extension CategoryCellTests {
    class FakeDataSource: NSObject, UITableViewDataSource {

        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }

        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            return UITableViewCell()
        }
    }
}
