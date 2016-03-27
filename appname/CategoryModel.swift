//
//  Category.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 27/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryModel: Object, Equatable {
    dynamic var name = ""
}

func ==(lhs: CategoryModel, rhs: CategoryModel) -> Bool {
    if lhs.name != rhs.name {
        return false
    }
    return true
}
