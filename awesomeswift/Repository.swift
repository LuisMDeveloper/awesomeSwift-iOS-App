//
//  ModelRepository.swift
//  awesomeswift
//
//  Created by Matteo Crippa on 10/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import RealmSwift

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