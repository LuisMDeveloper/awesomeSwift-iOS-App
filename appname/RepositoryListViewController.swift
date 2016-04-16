//
//  RepositoryListViewController.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 16/04/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import CacheManager
import DGElasticPullToRefresh
import UIKit

class RepositoryListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var repositoryManager = RepositoryManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        repositoryManager.delegate = self

        // Initialize tableView
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = .whiteColor()
        tableView.dg_addPullToRefreshWithActionHandler({ [unowned self] () -> Void in
            self.repositoryManager.getRemoteItems({ error in
                self.tableView.dg_stopLoading()
            })
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 247/255.0, green: 67/255.0, blue: 151/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RepositoryListViewController: CacheManagerDelegate {
    func cacheHasUpdate() {
        tableView.reloadData()
    }
}

extension RepositoryListViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCellWithIdentifier("RepositoryCell", forIndexPath: indexPath) as! RepositoryCell
        cell.configCellWithRepository(repositoryManager.itemAt(indexPath.row)!)
        return cell
    }
}

extension RepositoryListViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: need to filter by category
        return repositoryManager.count
    }
}
