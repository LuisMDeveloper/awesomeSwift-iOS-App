//
//  CategoryManager.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 27/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import CacheManager
import Foundation
import RealmSwift

class CategoryManager: CacheManager<CategoryModel> {

    private let net = Networking()

    override init() {
        super.init()
    }

    override func getRemoteItems(completion: (error: NSError?)->()) {
        net.getCats {
            cats, error in
            if error == nil {
                if cats!.count > 0 {
                    log.debug("Cats add items from network")
                    super.itemAddFromArray(cats!)
                    completion(error: nil)
                }
            } else {
                completion(error: error)
            }
        }
    }


   /* override func getRemoteItems() {
        net.getCats {
            cats, error in
            if error == nil {
                if cats!.count > 0 {
                    log.debug("Cats add items from network")
                    super.itemAddFromArray(cats!)
                }
            }
        }
    }*/

}
