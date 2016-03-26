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
        return self.stringByAddingPercentEncodingWithAllowedCharacters(
            NSCharacterSet.URLHostAllowedCharacterSet()
            )!
    }
}

enum AwesomeSwift {
    case Repos()
    case Cats()
}

extension AwesomeSwift: TargetType {

    var baseURL: NSURL { return NSURL(string: "http://matteocrippa.it/awesomeswift")! }

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

struct RepoNetwork {

    let provider: MoyaProvider<AwesomeSwift>

    func getCategories(callback: (Bool) -> Void) {
        self.provider
            .request(AwesomeSwift.Cats()) {
                result in
                switch result {
                case let .Success(moyaResponse):
                    let data = moyaResponse.data
                    let json = JSON(data: data)

                    var cats = [Category]()

                    for cat in json.arrayValue {
                        cats.append(self.catJsonToRealm(cat))
                    }

                    // swiftlint:disable force_try
                    try! realm.write() {
                        realm.add(cats, update: true)
                        callback(true)
                    }

                case let .Failure(error):
                    Log.error(error)
                    callback(false)
                }
        }
    }

    func getRepositories(callback: (Bool) -> Void) {

        self.provider
            .request(AwesomeSwift.Repos()) {
                result in
                switch result {
                case let .Success(moyaResponse):

                    let data = moyaResponse.data
                    let json = JSON(data: data)

                    var repos = [Repository]()

                    for repo in json.arrayValue {
                        repos.append(self.repoJsonToRealm(repo))
                    }

                    // swiftlint:disable force_try
                    try! realm.write() {
                        realm.add(repos, update: true)
                        callback(true)
                    }

                    case let .Failure(error):
                    Log.error(error)
                    callback(false)
                }
        }
    }

    func catJsonToRealm(json: JSON) -> Category {

        Log.debug(json)

        let cat = Category()

        guard let name = json["name"].string else {
            return cat
        }
        cat.name = name

        return cat
    }

    func repoJsonToRealm(json: JSON) -> Repository {

        Log.debug(json)

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

        guard let cat = json["category"].string else {
            return repo
        }
        repo.category = cat


        repo.createdAt = NSDate()

        return repo
    }
}
