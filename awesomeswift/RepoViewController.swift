//
//  RepoViewController.swift
//  awesomeswift
//
//  Created by Matteo Crippa on 05/02/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit
import SwiftDate
import SafariServices
import RealmSwift

class RepoViewController: UIViewController, UISearchBarDelegate, UIViewControllerPreviewingDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView : UITableView!
    
    @IBOutlet var searchConstant : NSLayoutConstraint!
    
    var listRepos = Results<Repository>?()
    
    var listReposFiltered = Results<Repository>?()
    
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
    
    // MARK: - Table delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.listReposFiltered!.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:RepoTableViewCell = tableView.dequeueReusableCellWithIdentifier("repoCell",
            forIndexPath: indexPath) as! RepoTableViewCell
        
        
        let repo = self.listReposFiltered![indexPath.row]
        
        cell.repoName.text = repo.name
        
        cell.repoDescription.text = repo.descr
        
        cell.repoNew.hidden = true
        
        // force new if it is listed within the last 24h
        if repo.createdAt >  1.days.ago {
            cell.repoNew.hidden = false
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let repo = self.listReposFiltered![indexPath.row]
        
        // open browser
        if let requestUrl = NSURL(string: repo.url) {
            let sfvc = SFSafariViewController.init(URL: requestUrl)
            
            self.showViewController(sfvc, sender: self)
            
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)

        
    }

    
    // MARK: - Pop
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        
    }
    
    // MARK: UIViewControllerPreviewingDelegate methods
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = self.tableView.indexPathForRowAtPoint(location) else { return nil }
        
        let repo = self.listReposFiltered![indexPath.row]
        
        // open browser
        if let requestUrl = NSURL(string: repo.url) {
            let sfvc = SFSafariViewController.init(URL: requestUrl)
        
            return sfvc
        }
        
        return nil
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        
        showViewController(viewControllerToCommit, sender: self)
        
    }
    
    // MARK: - Search
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        //print(searchText)
        
        if searchText.characters.count > 0 {
            let predicate = NSPredicate(format: "name contains %@ || descr contains %@", argumentArray: [searchText, searchText])
            
            self.listReposFiltered = self.listRepos?.filter(predicate)

        }else{
            self.listReposFiltered = self.listRepos
        }
        
        self.tableView.reloadData()
        
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

// MARK: - Safari exentsion
extension SFSafariViewController {
    
    override public func previewActionItems() -> [UIPreviewActionItem] {
        
        let deleteAction =  UIPreviewAction(title: "Cancel",
            style: UIPreviewActionStyle.Destructive,
            handler: {
                (previewAction,viewController) in
                
                NSLog("Delete")
                
        })
        
        
        return [deleteAction]
    }
    
}


