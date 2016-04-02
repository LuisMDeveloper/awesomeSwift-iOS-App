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

    override static func primaryKey() -> String? {
        return "name"
    }

    func mapping(item: JSON) {
        self.name = item["name"].stringValue
    }
}

func ==(lhs: CategoryModel, rhs: CategoryModel) -> Bool {
    if lhs.name != rhs.name {
        return false
    }
    return true
}
