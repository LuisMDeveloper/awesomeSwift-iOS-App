//
//  Configuration.swift
//  awesomeswift
//
//  Created by Matteo Crippa on 20/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import Foundation
import RealmSwift

/*let realmConfig = Realm.Configuration(
    schemaVersion: 1,
    
    migrationBlock: { migration, oldSchemaVersion in
        
        /*migration.enumerate(Category.className()) { oldObject, newObject in
            if oldSchemaVersion < 1 {
                newObject!["primaryKeyProperty"] = "name"
            }
        }
        
        migration.enumerate(Repository.className()) { oldObject, newObject in
            if oldSchemaVersion < 1 {
                newObject!["primaryKeyProperty"] = "name"
            }
        }*/
        
        print("Migration complete.")
})*/

let realm = try! Realm()
