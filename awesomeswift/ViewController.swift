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
import DGElasticPullToRefresh
import RealmSwift

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView : UITableView!
    @IBOutlet var loader : UIActivityIndicatorView!
    
    let apiEndpoint = "http://matteocrippa.it/awesomeswift/scraper.php"
    
    
    var listCats = Results<Category>?()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()

        self.listCats  = realm.objects(Category).sorted("name")


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
                    
                    let realm = try! Realm()
                
                    
                    // loop repos
                    for item in JSON as! Array<AnyObject> {
                        
                        if let urlR = item["url"]{
                            
                            let predicate = NSPredicate(format: "url = %@", argumentArray: [urlR!])

                            let isRepo = realm.objects(Repository).filter(predicate)
                            
                            //print(isRepo)
                            
                            if isRepo.count == 0 {
                                
                                let repo = Repository()
                                
                                if let name = item["name"] {
                                    repo.name = name as! String
                                }
                                
                                if let url = item["url"] {
                                    //print(url)
                                    repo.url = url as! String
                                }
                                
                                if let description = item["description"] {
                                    repo.descr = description as! String
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
                                let isCat = realm.objects(Category).filter("name contains '\(category)'")

                                //print(repo)
                                
                                try! realm.write {
                                    realm.add(repo)
                                }
                                
                                // create category
                                if isCat.count == 0 {
                                    
                                    let c = Category()
                                    c.name = category
                                    
                                    c.repos.append(repo)
                                    
                                    try! realm.write {
                                        realm.add(c)
                                    }
                                    
                                }else{
                                    
                                    let c = isCat[0]
                                    
                                    try! realm.write {
                                        c.repos.append(repo)
                                    }

                                }

                                
                            }
                        }

                    }
                    
                    self.listCats  = realm.objects(Category).sorted("name")

                    self.tableView.dg_stopLoading()

                    self.tableView.reloadData()
                    
                }
                
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if listCats!.count > 0 {
            self.loader.stopAnimating()
        }
        
        
        return listCats!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:RepoTableViewCell = tableView.dequeueReusableCellWithIdentifier("repoCell",
            forIndexPath: indexPath) as! RepoTableViewCell
        
        
        let cat = self.listCats![indexPath.row] as Category
        
        cell.repoName.text = cat.name
        
        let repos = cat.repos.count
            
        if repos == 1 {
            cell.repoDescription.text = "1 Repository"
        }else{
            cell.repoDescription.text = "\(repos) Repositories"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("showRepo", sender: self)
        
    }
        
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "showRepo") {
            
            let index = self.tableView.indexPathForSelectedRow!
            
            let cat = self.listCats![index.row] as Category
            
            let svc = segue.destinationViewController as! RepoViewController
            
            svc.catName = cat.name
            svc.title = svc.catName
            
            let repos = cat.repos.sorted("name")
            svc.listRepos = repos
            
            
            self.tableView.deselectRowAtIndexPath(self.tableView.indexPathForSelectedRow!, animated: false)
            
        }
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    
}

// MARK: - Scrollview fix
extension UIScrollView {
    func dg_stopScrollingAnimation() {}
}