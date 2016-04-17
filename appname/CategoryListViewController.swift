//
//  CategoryListViewController.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 28/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import CacheManager
import DGElasticPullToRefresh_CanStartLoading
import UIKit

class CategoryListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var categoryManager = CategoryManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        categoryManager.delegate = self

        // Initialize tableView
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = .whiteColor()
        tableView.dg_addPullToRefreshWithActionHandler({ [unowned self] () -> Void in
            self.categoryManager.getRemoteItems({ error in
                self.tableView.dg_stopLoading()
            })
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 247/255.0, green: 67/255.0, blue: 151/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)

        self.performSelector(#selector(CategoryListViewController.updateWithLittleDelay), withObject: nil, afterDelay: 0.1)
    }

    func updateWithLittleDelay() {
        tableView.dg_startLoading()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        // swiftlint:disable force_cast
        let vc = segue.destinationViewController as! RepositoryListViewController

        let catSelected = self.categoryManager.itemAt(tableView.indexPathForSelectedRow!.row)
        vc.title = catSelected!.name
        tableView.deselectSelectedRow()
    }

}

extension CategoryListViewController: CacheManagerDelegate {
    func cacheHasUpdate() {
        tableView.reloadData()
    }
}

extension CategoryListViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath) as! CategoryCell
        cell.configCellWithCategory(categoryManager.itemAt(indexPath.row)!)
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showRepositories", sender: self)
    }
}

extension CategoryListViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryManager.count
    }
}

extension UITableView {
    func deselectSelectedRow() {
        if let selected = self.indexPathForSelectedRow {
            self.deselectRowAtIndexPath(selected, animated: false)
        }
    }
}

extension UIScrollView {
    func dg_stopScrollingAnimation() {}
}
