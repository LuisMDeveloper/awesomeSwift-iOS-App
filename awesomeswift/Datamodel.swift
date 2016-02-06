//
//  Datamodel.swift
//  awesomeswift
//
//  Created by Matteo Crippa on 05/02/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import RealmSwift

// Dog model
class Repository: Object {
    dynamic var name = ""
    dynamic var descr = ""
    dynamic var url = ""
    dynamic var createdAt = NSDate()
    
    var category: [Category] {
        return linkingObjects(Category.self, forProperty: "repos")
    }
    
    override static func indexedProperties() -> [String] {
        return ["name"]
    }
}

// Person model
class Category: Object {
    dynamic var name = ""
    let repos = List<Repository>()
    dynamic var createdAt = NSDate()
    
    override static func indexedProperties() -> [String] {
        return ["name"]
    }
}