//
//  CategoryCellTests.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 28/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit
import Nimble
import Quick
@testable import AwesomeSwift

class CategoryCellTests: QuickSpec {
    override func spec() {

        var cell: CategoryCell!

        var firstCat: CategoryModel!

        beforeEach() {
            firstCat = CategoryModel()
            firstCat.name = "name"

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            // swiftlint:disable force_cast
            let vc = storyboard.instantiateViewControllerWithIdentifier("CategoryListViewController") as! CategoryListViewController
            _ = vc.view
            let tv = vc.tableView
            let fakeDataSource = FakeDataSource()
            tv.dataSource = fakeDataSource
            // swiftlint:disable force_cast
            cell = tv.dequeueReusableCellWithIdentifier(
                "CategoryCell",
                forIndexPath: NSIndexPath(forRow: 0, inSection: 0)
            ) as! CategoryCell
        }

        describe("a category cell") {
            it("has name label") {
                expect(cell.textLabel).toNot(beNil())
            }
            it("sets cat name label") {
                cell.configCellWithCategory(firstCat)
                expect(cell.textLabel!.text).to(equal("name"))
            }
        }
    }
}

extension CategoryCellTests {
    class FakeDataSource: NSObject, UITableViewDataSource {
        func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
        }

        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            return CategoryCell()
        }
    }
}
