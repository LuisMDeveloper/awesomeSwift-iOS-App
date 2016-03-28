//
//  RepositoryModel.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 27/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit
import RealmSwift

class RepositoryModel: Object, Equatable {
    dynamic var name = ""
    dynamic var descr = ""
    dynamic var category = ""
    dynamic var url = ""
    dynamic var createdAt = NSDate()
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
