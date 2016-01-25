//
//  ViewController.swift
//  awesomeswift
//
//  Created by Matteo Crippa on 24/01/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit
import Parse
import Bolts
import SwiftDate

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet var tableView : UITableView!
    
    @IBOutlet var segmentedFilter : UISegmentedControl!

    @IBOutlet var searchConstant : NSLayoutConstraint!
    
    var repos = [String:[PFObject]]()
    
    var repoCats = [String]()
    
    var remoteObjects = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // hide search
        self.searchConstant.constant = 0
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // force update
        self.loadRemoteData()
        
        // hide search
        self.searchConstant.constant = 0
    }
    

    func loadRemoteData() {
        
        let query = PFQuery(className:"Repo")
        query.cachePolicy = .NetworkElseCache
        query.orderByAscending("category")
        query.addAscendingOrder("subCategory")
        query.addAscendingOrder("subSubCategory")
        query.addAscendingOrder("name")
        
        query.limit = 1000
        
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                self.remoteObjects = objects!
                
                self.filterItems(false, search: "")
                
            } else {
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func filterItems (onlyNew: Bool, search: String) {
        
        for repo in self.remoteObjects {
            
            // retrieve cats
            var catName = repo["category"] as! String
            
            if let subCat = repo["subCategory"] {
                catName = catName+" "+(subCat as! String)
            }
            
            // check cat and add it if not listed yet
            if self.repoCats.contains(catName) == false {
                self.repoCats.append(catName)
            }
            
            if (self.repos[catName] == nil) {
                self.repos[catName] = [PFObject]()
            }
            
            if onlyNew == true {
                
                if repo.createdAt >  1.days.ago {
                    self.repos[catName]?.append(repo)
                }
                
            }else{
                self.repos[catName]?.append(repo)
            }
            
        }
        
        //print(self.repoCats)
        
        //print(self.repos)
        
        self.tableView.reloadData()
        
    }
    
    
    // MARK: - Table delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let key = self.repoCats[section]
        
        return self.repos[key]!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:RepoTableViewCell = tableView.dequeueReusableCellWithIdentifier("repoCell") as! RepoTableViewCell
        
        let key = self.repoCats[indexPath.section]
        
        let reposOfCat = self.repos[key]! as [PFObject]

        let current = reposOfCat[indexPath.row]
        
        cell.repoName.text = current["name"] as? String
        cell.repoDescription.text = current["description"] as? String
        
        cell.repoNew.hidden = true
        
        //print(1.days.ago)
        //print(current.createdAt)
        
        // force new if it is listed within the last 24h
        if current.createdAt >  1.days.ago {
            cell.repoNew.hidden = false
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // open browser
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.repoCats[section] 
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return self.repoCats.count
        
    }

    // MARK: - Filter
    
    @IBAction func changeFilter() {
        
        //print(self.segmentedFilter.selectedSegmentIndex)
        
        let index = self.segmentedFilter.selectedSegmentIndex
        
        if index == 0 {
            self.filterItems(false, search: "")
        }else{
            self.filterItems(true, search: "")
        }
        
    }

    // MARK: - Search
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
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

