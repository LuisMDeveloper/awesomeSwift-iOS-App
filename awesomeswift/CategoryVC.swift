//
//  ViewController.swift
//  awesomeswift
//
//  Created by Matteo Crippa on 24/01/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
import RealmSwift

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var loader : UIActivityIndicatorView!
    
    let realm = try! Realm()

    var listCats = Results<Category>?() {
        didSet {
            self.tableView.dg_stopLoading()
            self.tableView.reloadData()
        }
    }
    
    var viewModel: CategoryListVVM? {
        didSet {
            viewModel?.categories.observe{
                categories in
                self.listCats = categories
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup pull to refresh
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.whiteColor()
        self.tableView.dg_addPullToRefreshWithActionHandler({ [unowned self] () -> Void in
                self.viewModel = CategoryListVVMFromJson()
            }, loadingView: loadingView)
        self.tableView.dg_setPullToRefreshFillColor(UIColor(red: 97/255.0, green: 31/255.0, blue: 88/255.0, alpha: 1.0))
        self.tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewModel = CategoryListVVMFromJson()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        
    }
    
}

// MARK: - Table delegate
extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.listCats == nil {
            self.loader.stopAnimating()
            return 0
        }
        
        return self.listCats!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell:CategoryTableViewCell = tableView.dequeueReusableCellWithIdentifier("catCell",
            forIndexPath: indexPath) as! CategoryTableViewCell
        
        let cat = self.listCats![indexPath.row] as Category
        let viewModel = CategoryVVMFromCategory(cat)
        
        cell.viewModel = viewModel
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("showRepo", sender: self)
        
    }
    
}


// MARK: - Scrollview fix
extension UIScrollView {
    func dg_stopScrollingAnimation() {}
}