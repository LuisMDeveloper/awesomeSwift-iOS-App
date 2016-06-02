//
//  AwesomeSwiftAPI.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 02/06/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import Foundation
import Moya
import RealmSwift
import SwiftyJSON

enum AwesomeSwiftAPI {
    case Repos()
}

extension AwesomeSwiftAPI: TargetType {
    var baseURL: NSURL {
        return NSURL(string: "https://raw.githubusercontent.com/matteocrippa/awesome-swift/master")!
    }
    var path: String {
        switch self {
        case .Repos():
            return "/contents.json"
        }
    }
    var method: Moya.Method {
        return .GET
    }
    var parameters: [String: AnyObject]? {
        switch self {
        default:
            return nil
        }
    }
    var sampleData: NSData {
        switch self {
        case .Repos():
            return "{}".dataUsingEncoding(NSUTF8StringEncoding)!
        }
    }
}

struct API {
    let provider = MoyaProvider<AwesomeSwiftAPI>()

    func getRepos(callback: (JSON?, NSError?) -> ()) {
        self
            .provider
            .request(AwesomeSwiftAPI.Repos()) {
                result in
                switch result {
                    case let .Success(res):
                        let repos = JSON(data: res.data)
                        callback(repos, nil)
                    case let .Failure(error):
                        callback(nil, error.nsError)
                }
        }
    }
}
