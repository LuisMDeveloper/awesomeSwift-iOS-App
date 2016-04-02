//
//  CategoryManager.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 27/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import CacheManager
import Foundation
import Log
import RealmSwift

class CategoryManager: CacheManager {

    let net = Networking()

    override func itemsFromCache() {
        // swiftlint:disable force_try
        super.items = Array(super.realm.objects(CategoryModel))
        Log.debug(super.items)
    }

    override func itemsFromRemote() {
        net.getCats {
            cats, error in
            if error == nil {
                if cats!.count > 0 {
                    Log.debug("Cats add items from network")
                    super.itemAddFromArray(cats!)
                }
            }
        }
    }
}
