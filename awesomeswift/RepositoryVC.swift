//
//  RepoViewController.swift
//  awesomeswift
//
//  Created by Matteo Crippa on 05/02/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
import SafariServices
import RealmSwift
import Moya
import Log
import ReactiveKit
import ReactiveUIKit

class RepoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchConstant: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!

    private let provider = MoyaProvider<AwesomeSwift>()

    private var repoTracker: RepoNetwork!
    
    private var reposAll: Results<Repository> = { realm.objects(Repository).sorted("name") }() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var reposFiltered = Results<Repository>?() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        repoTracker = RepoNetwork(provider: provider)

        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.whiteColor()
        tableView.dg_addPullToRefreshWithActionHandler({ [unowned self] () -> Void in

            self.repoTracker.getRepositories { [unowned self] success in
                if success {
                    self.reposAll = realm.objects(Repository).sorted("name")
                }

                self.tableView.dg_stopLoading()
            }


            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(
            UIColor(red: 97/255.0, green: 31/255.0, blue: 88/255.0, alpha: 1.0)
        )
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)

        // hide search
        searchConstant.constant = 0

        // check for force touch
        if traitCollection.forceTouchCapability == .Available {
            registerForPreviewingWithDelegate(self, sourceView: view)
        }

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        self.repoTracker.getRepositories { [unowned self] success in
            if success {
                self.reposAll = realm.objects(Repository).sorted("name")
            }
        }

        // hide search
        self.searchConstant.constant = 0

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func toggleSearch() {

        UIView.animateWithDuration(0.55, animations: {

            if self.searchConstant.constant == 44 {
                self.searchConstant.constant = 0
                self.searchBar.resignFirstResponder()
            } else {
                self.searchConstant.constant = 44
            }

            self.view.setNeedsUpdateConstraints()

            self.view.layoutIfNeeded()
        })

    }
}

extension RepoViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSectionsInTableView(
        tableView: UITableView
        ) -> Int {
        return 1
    }

    func tableView(
        tableView: UITableView,
        numberOfRowsInSection section: Int
        ) -> Int {

        if searchBar.text?.characters.count == 0 {
            return self.reposAll.count
        } else {
            return self.reposFiltered!.count
        }
    }

    func tableView(
        tableView: UITableView,
        titleForHeaderInSection section: Int
        ) -> String? {
        if searchBar.text?.characters.count == 0 {
            return ""
        } else {
            return "Results"
        }
    }

    func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath
        ) -> UITableViewCell {

        guard let cell: RepoTableViewCell = tableView.dequeueReusableCellWithIdentifier(
            "repoCell",
            forIndexPath: indexPath
            ) as? RepoTableViewCell else {
            return RepoTableViewCell()
        }


        var repo: Repository!

        if searchBar.text?.characters.count == 0 {
            repo = reposAll[indexPath.row]
        } else {
            repo = reposFiltered![indexPath.row]
        }

        cell.configureWithModel(repo)

        return cell

    }

    func tableView(
        tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath
        ) {

        guard let cell: RepoTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as? RepoTableViewCell else {
           return
        }

        // open browser
        if let requestUrl = NSURL(string: cell.repo.url) {
            let sfvc = SFSafariViewController.init(URL: requestUrl)

            self.showViewController(sfvc, sender: self)

        }

        tableView.deselectRowAtIndexPath(indexPath, animated: false)

    }
}

extension RepoViewController: UIViewControllerPreviewingDelegate {

    override func traitCollectionDidChange(
        previousTraitCollection: UITraitCollection?
        ) {

    }

    func previewingContext(
        previewingContext: UIViewControllerPreviewing,
        viewControllerForLocation location: CGPoint
        ) -> UIViewController? {

        let indexPath = self.tableView.indexPathForRowAtPoint(location)

        guard let cell: RepoTableViewCell = tableView.cellForRowAtIndexPath(indexPath!) as? RepoTableViewCell else {
            return nil
        }

        // open browser
        if let requestUrl = NSURL(string: cell.repo.url) {
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

extension RepoViewController: UISearchBarDelegate {

    func searchBar(
        searchBar: UISearchBar,
        textDidChange searchText: String
        ) {

        if searchText.characters.count == 0 {
            self.reposFiltered = realm.objects(Repository).sorted("name")

        } else {
            let filter = NSPredicate(
                format: "name CONTAINS[NC] %@ || descr CONTAINS[NC] %@",
                searchText,
                searchText
            )
            self.reposFiltered = realm.objects(Repository).filter(filter).sorted("name")
        }
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

}

extension SFSafariViewController {

    override public func previewActionItems() -> [UIPreviewActionItem] {

        let deleteAction =  UIPreviewAction(title: "Cancel",
            style: UIPreviewActionStyle.Destructive,
            handler: {
                (previewAction, viewController) in

                Log.debug("Delete")

        })


        return [deleteAction]
    }

}

extension UIScrollView {
    func dg_stopScrollingAnimation() {}
}
