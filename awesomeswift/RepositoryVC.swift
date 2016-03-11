//
//  RepoViewController.swift
//  awesomeswift
//
//  Created by Matteo Crippa on 05/02/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit
import SafariServices
import RealmSwift

class RepoViewController: UIViewController {
    
    @IBOutlet var tableView : UITableView!
    
    @IBOutlet var searchConstant : NSLayoutConstraint!
    
    var listRepos = Results<Repository>?(){
        didSet {
            guard (self.tableView != nil) else {
                return
            }
            
            self.tableView.reloadData()

        }
    }
    
    var listReposFiltered = Results<Repository>?(){
        didSet {
            guard (self.tableView != nil) else {
                return
            }
            
            self.tableView.reloadData()
        }
    }
    
    var catName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listReposFiltered = self.listRepos
        
        // hide search
        self.searchConstant.constant = 0
        
        // check for force touch
        if( traitCollection.forceTouchCapability == .Available){
            
            registerForPreviewingWithDelegate(self, sourceView: view)
            
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
                
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

// MARK: - Table delegate
extension RepoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.listReposFiltered!.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:RepoTableViewCell = tableView.dequeueReusableCellWithIdentifier("repoCell",
            forIndexPath: indexPath) as! RepoTableViewCell
        
        
        let repo = self.listReposFiltered![indexPath.row]
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

// MARK: UIViewControllerPreviewingDelegate methods
extension RepoViewController: UIViewControllerPreviewingDelegate {
    // MARK: - Pop
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = self.tableView.indexPathForRowAtPoint(location) else { return nil }
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! RepoTableViewCell
        
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

// MARK: - UISearchBarDelegate
extension RepoViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.characters.count > 0 {
            let predicate = NSPredicate(format: "name contains %@ || descr contains %@", argumentArray: [searchText.lowercaseString, searchText.lowercaseString])
            
            self.listReposFiltered = self.listRepos?.filter(predicate)
            
        }else{
            self.listReposFiltered = self.listRepos
        }
        
    }
    
}

// MARK: - Safari exentsion
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


