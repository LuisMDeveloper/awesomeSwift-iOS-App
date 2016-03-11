//
//  Networking.swift
//  awesomeswift
//
//  Created by Matteo Crippa on 11/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import Alamofire
import RealmSwift
import UIKit

let apiEndpoint = "http://matteocrippa.it/awesomeswift/scraper.php"

protocol CategoryListVVM {
    var categories: Dynamic<Results<Category>?> {get}
}

class CategoryListVVMFromJson: CategoryListVVM {
    
    let realm = try! Realm()

    var categories: Dynamic<Results<Category>?>

    init(){
        
        self.categories = Dynamic(nil)
        
        Alamofire.request(.GET, apiEndpoint)
            .responseJSON { [unowned self] response in
                
                if let JSON = response.result.value {
                    
                    // loop repos
                    for item in JSON as! Array<AnyObject> {
                        
                        if let urlR = item["url"]{
                            
                            let predicate = NSPredicate(format: "url = %@", argumentArray: [urlR!])
                            
                            let isRepo = self.realm.objects(Repository).filter(predicate)
                            
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
                                let isCat = self.realm.objects(Category).filter("name contains '\(category)'")
                                
                                //print(repo)
                                
                                try! self.realm.write {
                                    self.realm.add(repo)
                                }
                                
                                // create category
                                if isCat.count == 0 {
                                    
                                    let c = Category()
                                    c.name = category
                                    
                                    c.repos.append(repo)
                                    
                                    try! self.realm.write {
                                        self.realm.add(c)
                                    }
                                    
                                }else{
                                    
                                    let c = isCat[0]
                                    
                                    try! self.realm.write {
                                        c.repos.append(repo)
                                    }
                                    
                                }
                                
                                
                            }
                        }
                        
                    }
                    
                    self.categories.value = self.realm.objects(Category).sorted("name")
                    
                }
                
        }
        
    }

}
