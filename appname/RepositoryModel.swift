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

class RepositoryModel: Object, Equatable {
    dynamic var name = ""
    dynamic var descr = ""
    dynamic var category = ""
    dynamic var url = ""
    dynamic var createdAt = NSDate()

    override static func primaryKey() -> String? {
        return "name"
    }

    func mapping(item: JSON) {
        self.name = item["name"].stringValue
        self.descr = item["descr"].stringValue
        self.category = item["category"].stringValue
        self.url = item["url"].stringValue
    }
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
    
    if lhs.createdAt != rhs.createdAt {
        return false
    }

    return true
}
