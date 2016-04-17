//
//  RepositoryManager.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 27/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import CacheManager
import Foundation

class RepositoryManager: CacheManager<RepositoryModel> {
    private let net = Networking()

    override init() {
        super.init()
    }

    override func getRemoteItems(completion: (error: NSError?)->()) {
        net.getRepositories {
            repos, error in
            if error == nil {
                if repos!.count > 0 {
                    log.debug("Repos add items from network")
                    super.itemAddFromArray(repos!)
                    completion(error: nil)
                }
            } else {
                completion(error: error)
            }
        }
    }

}
