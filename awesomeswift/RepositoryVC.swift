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
import RxSwift
import RxCocoa
import Moya
import Log

class RepoViewController: UIViewController {
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var searchConstant : NSLayoutConstraint!
    @IBOutlet weak var loader : UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let disposeBag = DisposeBag()
    private let viewModel = RepositoryViewModel()
    
    private let provider = MoyaProvider<GitHub>()
    private var repoTracker: RepoNetwork!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        repoTracker = RepoNetwork(provider: provider, viewModel: viewModel)
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.whiteColor()
        tableView.dg_addPullToRefreshWithActionHandler({ [unowned self] () -> Void in
            self.repoTracker.getRepository()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 97/255.0, green: 31/255.0, blue: 88/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)

        // hide search
        searchConstant.constant = 0
        
        // check for force touch
        if( traitCollection.forceTouchCapability == .Available){
            registerForPreviewingWithDelegate(self, sourceView: view)
        }
        
        setupRx()
        
    }
    
    func setupRx() {
        
        tableView
            .rx_modelSelected(Repository)
            .subscribeNext { repo in
                Log.debug("Tapped `\(repo)`")
                if let requestUrl = NSURL(string: repo.url) {
                    let sfvc = SFSafariViewController.init(URL: requestUrl)
                    
                    self.showViewController(sfvc, sender: self)
                    
                }
                
                self.tableView.deselectRowAtIndexPath(self.tableView.indexPathForSelectedRow!, animated: false)

            }
            .addDisposableTo(disposeBag)
                
        viewModel.repos
            .subscribeNext {
                [unowned self] repos in
                Log.debug("Stop loading")
                self.tableView.dg_stopLoading()
        }
                
        viewModel.repos
            .bindTo(tableView.rx_itemsWithCellIdentifier("repoCell", cellType: RepoTableViewCell.self)) {
                row, repo, cell in
                cell.setupCell(repo)
            }
            .addDisposableTo(disposeBag)
        
        searchBar
            .rx_text
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribeNext {
                [unowned self] (query) in
                Log.debug(query)
                if query.characters.count > 0 {
                    self.viewModel.filter(query)
                } else {
                    self.viewModel.update()
                }
            }
            .addDisposableTo(disposeBag)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
                
        viewModel.update()
        self.repoTracker.getRepository()

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
            }else{
                self.searchConstant.constant = 44
            }
            
            self.view.setNeedsUpdateConstraints()
            
            self.view.layoutIfNeeded()
        })
        
    }
}

/*extension RepoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if self.listReposFiltered == nil {
            if self.listCats == nil {
                self.loader.stopAnimating()
                return 0
            }
            
            return self.listCats!.count
        }else{
            return 1
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.listReposFiltered == nil {
            return self.listCats![section].repos.count
        }else{
            return (self.listReposFiltered?.count)!
        }
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.listReposFiltered == nil {
            return self.listCats![section].name
        }else{
            return "Results"
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:RepoTableViewCell = tableView.dequeueReusableCellWithIdentifier("repoCell",
            forIndexPath: indexPath) as! RepoTableViewCell
        
        var repo = Repository()
        
        if self.listReposFiltered == nil {
            let cat = self.listCats![indexPath.section] as Category
            repo = cat.repos[indexPath.row] as Repository
        }else{
            repo = self.listReposFiltered![indexPath.row] as Repository
        }
        
        let viewModel = RepositoryVVMFromRepository(repo)
        
        cell.viewModel = viewModel
        
        return cell

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! RepoTableViewCell
        
        // open browser
        if let requestUrl = NSURL(string: cell.viewModel!.url.value) {
            let sfvc = SFSafariViewController.init(URL: requestUrl)
            
            self.showViewController(sfvc, sender: self)
            
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        
    }
}*/

extension RepoViewController: UIViewControllerPreviewingDelegate {

    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let indexPath = self.tableView.indexPathForRowAtPoint(location)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath!) as! RepoTableViewCell
        
        // open browser
        /*if let requestUrl = NSURL(string: cell.viewModel!.url.value) {
            let sfvc = SFSafariViewController.init(URL: requestUrl)
            
            return sfvc
        }*/
        
        return nil
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        
        showViewController(viewControllerToCommit, sender: self)
        
    }

}

extension RepoViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.characters.count > 0 {
            let predicate = NSPredicate(format: "name CONTAINS[c] %@ || descr CONTAINS[c] %@", argumentArray: [searchText.lowercaseString, searchText.lowercaseString])
            
            //self.listReposFiltered = realm.objects(Repository).sorted("name").filter(predicate)
            
        }else{
            //self.listReposFiltered = Results<Repository>?()
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

extension SFSafariViewController {
    
    override public func previewActionItems() -> [UIPreviewActionItem] {
        
        let deleteAction =  UIPreviewAction(title: "Cancel",
            style: UIPreviewActionStyle.Destructive,
            handler: {
                (previewAction,viewController) in
                
                print("Delete")
                
        })
        
        
        return [deleteAction]
    }
    
}

extension UIScrollView {
    func dg_stopScrollingAnimation() {}
}