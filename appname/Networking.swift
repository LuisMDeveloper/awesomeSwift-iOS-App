//
//  Networking.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 02/04/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import Foundation
import Log
import Moya
import RealmSwift
import SwiftyJSON

enum AwesomeSwift {
    case Cats()
    case Repos()
}

extension AwesomeSwift: TargetType {
    var baseURL: NSURL {
        return NSURL(string: "http://matteocrippa.it/awesomeswift")!
    }
    var path: String {
        switch self {
        case .Cats():
            return "/cats.php"
        case .Repos():
            return "/repos.php"
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
        case .Cats():
            return "{}".dataUsingEncoding(NSUTF8StringEncoding)!
        case .Repos():
            return "{}".dataUsingEncoding(NSUTF8StringEncoding)!
        }
    }
}

struct Networking {
    let provider: MoyaProvider<AwesomeSwift>

    func getCats(callback: ([CategoryModel]?, NSError?) -> Void) {
        self.provider
            .request(AwesomeSwift.Cats()) {
                result in
                switch result {
                case let .Success(res):
                    Log.debug(res.data)
                    let cats = JSON(data: res.data)
                    var items = [CategoryModel]()
                    for cat in cats.arrayValue {
                        let item = CategoryModel()
                        item.mapping(cat)
                        items.append(item)
                    }
                    callback(items, nil)
                case let .Failure(err):
                    Log.error(err)
                    callback(nil, err.nsError)
                }
        }
    }

    func getRepositories(callback: ([RepositoryModel]?, NSError?) -> Void) {
        self.provider
            .request(AwesomeSwift.Repos()) {
                result in
                switch result {
                case let .Success(res):
                    Log.debug(res.data)
                    let repos = JSON(data: res.data)
                    var items = [RepositoryModel]()
                    for repo in repos.arrayValue {
                        let item = RepositoryModel()
                        item.mapping(repo)
                        items.append(item)
                    }
                    callback(items, nil)
                case let .Failure(err):
                    Log.error(err)
                    callback(nil, err.nsError)
                }
        }
    }
}

private extension String {
    var URLEscapedString: String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(
            NSCharacterSet.URLHostAllowedCharacterSet()
            )!
    }
}
