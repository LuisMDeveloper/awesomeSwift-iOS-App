//
//  RepositoryListViewController.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 16/04/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import CacheManager
import DGElasticPullToRefresh_CanStartLoading
import SafariServices
import UIKit

class RepositoryListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var repositoryManager = RepositoryManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        repositoryManager.delegate = self

        let predicate = NSPredicate(format: "category = %@", self.title!)
        repositoryManager.filter = predicate

        // Initialize tableView
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = .whiteColor()
        tableView.dg_addPullToRefreshWithActionHandler({ [unowned self] () -> Void in
            self.repositoryManager.getRemoteItems({ error in
                self.tableView.dg_stopLoading()
            })
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(kAwesomeColor)
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)

        // delay the update of repos
        self.performSelector(
            #selector(RepositoryListViewController.updateWithLittleDelay),
            withObject: nil,
            afterDelay: 0.2
        )

        // check for force touch
        if traitCollection.forceTouchCapability == .Available {
            registerForPreviewingWithDelegate(self, sourceView: view)
        }


        // TODO: fix bug refresh reset favorites
    }

    func updateWithLittleDelay() {
        tableView.dg_startLoading()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension RepositoryListViewController: CacheManagerDelegate {
    func cacheHasUpdate() {
        tableView.reloadData()
    }
}

extension RepositoryListViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCellWithIdentifier(
            "RepositoryCell",
            forIndexPath: indexPath
        ) as! RepositoryCell
        cell.delegate = self
        cell.tag = indexPath.row
        cell.configCellWithRepository(repositoryManager.itemAt(indexPath.row)!)
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let repo = repositoryManager.itemAt(indexPath.row)

        // open browser
        if let requestUrl = NSURL(string: repo!.url) {
            let sfvc = SFSafariViewController.init(URL: requestUrl)

            self.showViewController(sfvc, sender: self)

        }

        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}

extension RepositoryListViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoryManager.count
    }
}

extension RepositoryListViewController: RepositoryCellDelegate {
    func tappedFavorite(repo: RepositoryModel) {
        repositoryManager.itemUpdate(repo, key: "favorite", value: !repo.favorite)
    }
}

extension RepositoryListViewController: UISearchBarDelegate {

    func searchBar(
        searchBar: UISearchBar,
        textDidChange searchText: String
        ) {

        if searchText.characters.count == 0 {

            let predicate = NSPredicate(format: "category = %@", self.title!)
            repositoryManager.filter = predicate

        } else {
            let filter = NSPredicate(
                format: "category = %@ && (name CONTAINS[NC] %@ || descr CONTAINS[NC] %@)",
                self.title!,
                searchText,
                searchText
            )
            repositoryManager.filter = filter
        }
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

}

extension RepositoryListViewController: UIViewControllerPreviewingDelegate {

    override func traitCollectionDidChange(
        previousTraitCollection: UITraitCollection?
        ) {

    }

    func previewingContext(
        previewingContext: UIViewControllerPreviewing,
        viewControllerForLocation location: CGPoint
        ) -> UIViewController? {

        let indexPath = self.tableView.indexPathForRowAtPoint(location)

        guard let repo = repositoryManager.itemAt(indexPath!.row) else {
            return nil
        }

        // open browser
        if let requestUrl = NSURL(string: repo.url) {
            let sfvc = SFSafariViewController.init(URL: requestUrl)
            return sfvc
        }

        return nil
    }

    func previewingContext(
        previewingContext: UIViewControllerPreviewing,
        commitViewController viewControllerToCommit: UIViewController) {

        showViewController(viewControllerToCommit, sender: self)

    }

}
