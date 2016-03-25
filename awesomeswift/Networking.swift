//
//  Networking.swift
//  awesomeswift
//
//  Created by Matteo Crippa on 11/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import Alamofire
import UIKit
import RealmSwift
import Moya
import SwiftyJSON
import Log


private extension String {
    var URLEscapedString: String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
    }
}

enum GitHub {
    case Repos()
}

extension GitHub: TargetType {
    var baseURL: NSURL { return NSURL(string: "http://matteocrippa.it/awesomeswift")! }
    var path: String {
        switch self {
        case .Repos():
            return "/scraper.php"
        }
    }
    var method: Moya.Method {
        return .GET
    }
    var parameters: [String: AnyObject]? {
        return nil
    }
    var sampleData: NSData {
        switch self {
        case .Repos():
            return "{}".dataUsingEncoding(NSUTF8StringEncoding)!
        }
    }
}

struct RepoNetwork {
    
    let provider: MoyaProvider<GitHub>
    
    func getRepository(callback: (Bool) -> Void) {
        self.provider
            .request(GitHub.Repos()) {
                result in
                switch result {
                case let .Success(moyaResponse):
                    
                    let data = moyaResponse.data
                    let json = JSON(data: data)
                    
                    var repos = [Repository]()
                    
                    for repo in json.arrayValue {
                        repos.append(self.repoJsonToRealm(repo))
                    }
                    
                    try! realm.write() {
                        realm.add(repos, update: true)
                        callback(true)                        
                    }
                    
                case let .Failure(error):
                    print(error)
                    callback(false)
                }
        }
    }
    
    func repoJsonToRealm(json: JSON) -> Repository {
        
        //Log.debug(json)

        let repo = Repository()
        
        guard let name = json["name"].string else {
            return repo
        }
        repo.name = name
        
        guard let descr = json["description"].string else {
            return repo
        }
        repo.descr = descr
        
        guard let url = json["url"].string else {
            return repo
        }
        repo.url = url
        
        //guard let cat = json["category"].string else {
        //    return repo
        //}
        
        
        repo.createdAt = NSDate()
        
        return repo
    }
}



/*
class CategoryListVVMFromJson {
    
    init(){
        
        Alamofire.request(.GET, apiEndpoint)
            .responseJSON { [unowned self] response in
                
                if let JSON = response.result.value {
                    
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
                                    realm.add(repo, update: false)
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
                    
                    
                                        
                }
                
        }
        
    }

}*/
