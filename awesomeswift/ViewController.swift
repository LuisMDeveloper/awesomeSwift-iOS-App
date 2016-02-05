//
//  ViewController.swift
//  awesomeswift
//
//  Created by Matteo Crippa on 24/01/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit
import Alamofire
import SwiftDate
import Graph
import DGElasticPullToRefresh

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView : UITableView!
    
    let graph = Graph()
    
    //let apiEndpoint = "http://matteocrippa.it/awesomeswift/scraper.php"
    let apiEndpoint = "http://localhost/scraper.php"
    
    
    var listCats = [Entity]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listCats = self.graph.searchForEntity(types: ["Category"])

        // setup pull to refresh
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.whiteColor()
        self.tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.loadRemoteData()
            }, loadingView: loadingView)
        self.tableView.dg_setPullToRefreshFillColor(UIColor(red: 97/255.0, green: 31/255.0, blue: 88/255.0, alpha: 1.0))
        self.tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // force update
        self.loadRemoteData()
        
    }
    

    func loadRemoteData() {
        
        Alamofire.request(.GET, apiEndpoint)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    
                    // loop repos
                    for item in JSON as! Array<AnyObject> {
                        
                        if let urlR = item["url"]{
                            
                            let isRepo: Array<Entity> = self.graph.searchForEntity(properties: [(key: "url", value: urlR)])
                        
                            //print(isRepo)
                            
                            if isRepo.count == 0 {
                                
                                let repo: Entity = Entity(type: "Repository")
                                
                                if let name = item["name"] {
                                    repo["name"] = name
                                }
                                
                                if let url = item["url"] {
                                    repo["url"] = url
                                }
                                
                                if let description = item["description"] {
                                    repo["description"] = description
                                }
                                
                                var category = ""
                                
                                if let cat = item["cat"] {
                                    category = cat as! String
                                    //print(category)
                                }
                                
                                if let subcat = item["subcat"] {
                                    if subcat != nil {
                                        category = category+" "+(subcat as! String)
                                    }
                                }
                                
                                if let subsubcat = item["subsubcat"] {
                                    if subsubcat != nil {
                                        category = category+" "+(subsubcat as! String)
                                    }
                                }
                                
                                // check if category exist
                                let isCat: Array<Entity> = self.graph.searchForEntity(properties: [("name", category)])
                                
                                // add relationship
                                let rel: Action = Action(type: "Relation")
                                rel.addSubject(repo)

                                //print(repo)
                                
                                // create category
                                if isCat.count == 0 {
                                    let c: Entity = Entity(type: "Category")
                                    c["name"] = category
                                    rel.addObject(c)
                                }else{
                                    rel.addObject(isCat[0])
                                }
                                
                                // save
                                self.graph.save()
                                
                            }
                        }

                    }
                    
                    self.listCats = self.graph.searchForEntity(types: ["Category"])

                    self.tableView.dg_stopLoading()

                    self.tableView.reloadData()
                }
                
        }
        
        
        // self.filterItems(false, search: "")

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCats.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:RepoTableViewCell = tableView.dequeueReusableCellWithIdentifier("repoCell",
            forIndexPath: indexPath) as! RepoTableViewCell
        
        
        let cat = self.listCats[indexPath.row]
        
        if let name = cat["name"] {
            cell.repoName.text = name as! String
        } else {
            cell.repoName.text = ""
        }
        
        let repos = cat.actions.count
            
        if repos == 1 {
            cell.repoDescription.text = "1 Repository"
        }else{
            cell.repoDescription.text = "\(repos) Repositories"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("showRepo", sender: self)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
    }
        
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    
}