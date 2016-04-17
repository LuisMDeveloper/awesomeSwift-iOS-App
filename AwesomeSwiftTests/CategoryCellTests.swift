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
