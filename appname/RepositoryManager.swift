//
//  RepositoryManager.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 27/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import CacheManager
import Foundation
import RealmSwift

class RepositoryManager: CacheManager<RepositoryModel> {
    private let net = Networking()

    /*override func itemsFromCache() {
        // swiftlint:disable force_try
        super.items = Array(super.realm.objects(RepositoryModel))
        Log.debug(super.items)
    }
    override func itemsFromRemote() {
        net.getRepositories {
            repos, error in
            if error == nil {
                if repos!.count > 0 {
                    Log.debug("Repos add items from network")
                    super.itemAddFromArray(repos!)
                }
            }
        }
    }*/
}
