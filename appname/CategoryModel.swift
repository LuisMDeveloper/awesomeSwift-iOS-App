//
//  Category.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 27/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class CategoryModel: Object, Equatable {
    dynamic var name = ""
    dynamic var createdAt = NSDate()

    override class func primaryKey() -> String? {
        return "name"
    }

    convenience init(json: JSON) {
        self.init()
        mapping(json)
    }

    func mapping(json: JSON) {
        self.name = json["category"].stringValue
    }

    override func isEqual(object: AnyObject?) -> Bool {
        guard let rhs = object as? CategoryModel else {
            return false
        }
        return self == rhs
    }
}

func ==(lhs: CategoryModel, rhs: CategoryModel) -> Bool {
    if lhs.name != rhs.name {
        return false
    }
    return true
}
