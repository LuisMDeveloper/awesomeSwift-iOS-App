//
//  RepositoryManager.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 27/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit
import CacheManager
import RealmSwift

class RepositoryManager: CacheManager {
    required init() {
        super.init()
        super.items = [RepositoryModel]()
    }

    override func itemsFromCache() {
        // swiftlint:disable force_try
        super.items = Array(try! super.realm.objects(RepositoryModel))
    }
}
