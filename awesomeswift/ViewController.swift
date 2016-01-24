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

class ViewController: UIViewController {
    
    @IBOutlet var tableView : UITableView!

    var repos = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.loadRemoteData()
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
                
                self.repos = objects!
                self.tableView.reloadData()
                
                /*if let objects = objects {
                    for object in objects {
                        print(object)
                        
                    }
                }*/
                
                print(self.repos.count)
                
            } else {
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.repos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("repoCell")!
        
        let current = self.repos[indexPath.row]
        
        
        cell.textLabel?.text = current["name"] as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //self.performSegueWithIdentifier("goDetail", sender: indexPath)
        
    }

}

