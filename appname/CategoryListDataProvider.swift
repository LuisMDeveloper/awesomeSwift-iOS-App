//
//  CategoryListDataProvider.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 28/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit

class CategoryListDataProvider: NSObject, UITableViewDataSource, UITableViewDelegate {

    var categoryManager: CategoryManager?

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let categoryManager = categoryManager else { return 0 }
        return categoryManager.catCount
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath) as! CategoryCell
        if let category = categoryManager?.catAtIndex(indexPath.row) {
            cell.configCellWithCategory(category)
        }
        return cell
    }

}
