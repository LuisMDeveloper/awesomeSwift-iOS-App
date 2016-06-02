//
//  RepositoryModel.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 27/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class RepositoryModel: Object {
    dynamic var name = ""
    dynamic var descr = ""
    dynamic var category = ""
    dynamic var url = ""
    dynamic var createdAt = NSDate()
    dynamic var favorite = false

    override static func primaryKey() -> String? {
        return "name"
    }

    convenience init(json: JSON) {
        self.init()
        mapping(json)
    }

    func mapping(json: JSON) {
        self.name = json["name"].stringValue
        self.descr = json["descr"].stringValue
        self.category = json["category"].stringValue
        self.url = json["url"].stringValue
    }

    /*override func isEqual(object: AnyObject?) -> Bool {
        guard let rhs = object as? CategoryModel else {
            return false
        }
        return self == rhs
    }*/
}

func ==(lhs: RepositoryModel, rhs: RepositoryModel) -> Bool {

    if lhs.name != rhs.name {
        return false
    }

    if lhs.descr != rhs.descr {
        return false
    }

    if lhs.category != rhs.category {
        return false
    }

    if lhs.url != rhs.url {
        return false
    }

    return true
}
