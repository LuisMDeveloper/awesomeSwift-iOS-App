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
import Bond

class RepoViewController: UIViewController {
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var searchConstant : NSLayoutConstraint!
    @IBOutlet weak var loader : UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!

    private let realm = try! Realm()
    
    private var listReposFiltered = Results<Repository>?(){
        didSet {
            guard (self.tableView != nil) else {
                return
            }
            
            self.tableView.reloadData()
        }
    }
    private var listCats = Results<Category>?() {
        didSet {
            self.tableView.dg_stopLoading()
            self.tableView.reloadData()
        }
    }
    
    private var viewModel: CategoryListVVM? {
        didSet {
            viewModel?.categories.observe{
                categories in
                self.listCats = categories
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.whiteColor()
        self.tableView.dg_addPullToRefreshWithActionHandler({ [unowned self] () -> Void in
            self.viewModel = CategoryListVVMFromJson()
            }, loadingView: loadingView)
        self.tableView.dg_setPullToRefreshFillColor(UIColor(red: 97/255.0, green: 31/255.0, blue: 88/255.0, alpha: 1.0))
        self.tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)

        // hide search
        self.searchConstant.constant = 0
        
        // check for force touch
        if( traitCollection.forceTouchCapability == .Available){
            
            registerForPreviewingWithDelegate(self, sourceView: view)
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewModel = CategoryListVVMFromJson()

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

extension RepoViewController: UITableViewDelegate, UITableViewDataSource {
    
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
}

extension RepoViewController: UIViewControllerPreviewingDelegate {

    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let indexPath = self.tableView.indexPathForRowAtPoint(location)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath!) as! RepoTableViewCell
        
        // open browser
        if let requestUrl = NSURL(string: cell.viewModel!.url.value) {
            let sfvc = SFSafariViewController.init(URL: requestUrl)
            
            return sfvc
        }
        
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
            
            self.listReposFiltered = self.realm.objects(Repository).sorted("name").filter(predicate)
            
        }else{
            self.listReposFiltered = Results<Repository>?()
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