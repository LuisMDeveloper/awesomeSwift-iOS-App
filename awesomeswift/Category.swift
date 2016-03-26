//
//  Datamodel.swift
//  awesomeswift
//
//  Created by Matteo Crippa on 05/02/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import RealmSwift

class Category: Object {
    dynamic var name = ""

    override static func primaryKey() -> String {
        return "name"
    }

}
