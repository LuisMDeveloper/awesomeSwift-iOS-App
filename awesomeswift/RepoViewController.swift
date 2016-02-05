//
//  RepoViewController.swift
//  awesomeswift
//
//  Created by Matteo Crippa on 05/02/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit
import Graph
import SwiftDate
import SafariServices

class RepoViewController: UIViewController, UISearchBarDelegate, UIViewControllerPreviewingDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView : UITableView!
    
    @IBOutlet var segmentedFilter : UISegmentedControl!
    
    @IBOutlet var searchConstant : NSLayoutConstraint!
    
    var listRepos = [Entity]()
    var catName = ""
    
    let graph = Graph()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        return listRepos.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:RepoTableViewCell = tableView.dequeueReusableCellWithIdentifier("repoCell",
            forIndexPath: indexPath) as! RepoTableViewCell
        
        
        let repo = self.listRepos[indexPath.row]
        
        if let name = repo["name"] {
            cell.repoName.text = name as! String
        } else {
            cell.repoName.text = ""
        }
        
        if let description = repo["description"] {
            cell.repoDescription.text = description as! String
        } else {
            cell.repoDescription.text = ""
        }
                
        cell.repoNew.hidden = true
        
        // force new if it is listed within the last 24h
        if repo.createdDate >  1.days.ago {
            cell.repoNew.hidden = false
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("showRepo", sender: self)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Categories"
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return 1
    }

    
    // MARK: - Pop
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        
    }
    
    // MARK: UIViewControllerPreviewingDelegate methods
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = self.tableView.indexPathForRowAtPoint(location) else { return nil }
        
        // retrive object
        //let key = self.repoCats[indexPath.section]
        
        /*let reposOfCat = self.repos[key]! as [PFObject]
        
        let current = reposOfCat[indexPath.row]
        
        
        // open browser
        if let requestUrl = NSURL(string: current["url"] as! String) {
        let sfvc = SFSafariViewController.init(URL: requestUrl)
        
        return sfvc
        }else{
        return nil
        }*/
        
        return nil
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        
        showViewController(viewControllerToCommit, sender: self)
        
    }
    
    // MARK: - Filter
    
    @IBAction func changeFilter() {
        
        //print(self.segmentedFilter.selectedSegmentIndex)
        
        let index = self.segmentedFilter.selectedSegmentIndex
        
        if index == 0 {
        //    self.filterItems(false, search: "")
        }else{
        //    self.filterItems(true, search: "")
        }
        
    }
    
    // MARK: - Search
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        //print(searchText)
        
        let index = self.segmentedFilter.selectedSegmentIndex
        
        if index == 0 {
        //    self.filterItems(false, search: searchText)
        }else{
        //    self.filterItems(true, search: searchText)
        }
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
        
        let doneAction = UIPreviewAction(title: "Open",
            style: UIPreviewActionStyle.Default,
            handler: {
                (previewActin, viewController) in
                
                NSLog("Done")
        })
        
        return [doneAction, deleteAction]
    }
    
}


