//
//  CategoryManager.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 27/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryManager {
    private var cats = [CategoryModel]()
    private let realm = RealmProvider.realm()

    var catCount: Int {
        return cats.count
    }

    init() {
        updateFromRealm()
    }

    private func updateFromRealm() {
        // swiftlint:disable force_try
        cats = Array(try! Realm().objects(CategoryModel))
    }

    func addCat(cat: CategoryModel) {
        if !cats.contains(cat) {
            cats.append(cat)
            // swiftlint:disable force_try
            try! realm.write {
                realm.add(cat)
            }
        }
    }

    func catAtIndex(index: Int) -> CategoryModel? {
        let upperBound = self.cats.count
        if 0..<upperBound ~= index {
            return cats[index]
        } else {
            return nil
        }
    }

    func removeCatAtIndex(index: Int) {
        let upperBound = self.cats.count
        if 0..<upperBound ~= index {
            let cat = cats[index]
            cats.removeAtIndex(index)
            // swiftlint:disable force_try
            try! realm.write {
               realm.delete(cat)
            }
        }
    }

    func removeAllCats() {
        cats.removeAll()
        // swiftlint:disable force_try
        try! realm.write {
            realm.deleteAll()
        }
    }
}
