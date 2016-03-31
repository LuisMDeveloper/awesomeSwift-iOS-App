//
//  CategoryManager.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 27/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryManager: Manager {
    override init() {
        super.init()
        items = [CategoryModel]()
    }

    override func itemsFromCache() {
        // swiftlint:disable force_try
        items = Array(try! realm.objects(CategoryModel))
    }
}
