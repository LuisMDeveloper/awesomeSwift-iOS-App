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

    var catCount: Int {
        return self.cats.count
    }

    func addCat(cat: CategoryModel) {
        if !self.cats.contains(cat) {
            self.cats.append(cat)
        }
    }

    func catAtIndex(index: Int) -> CategoryModel {
        return self.cats[index]
    }

    func removeCatAtIndex(index: Int) {
        self.cats.removeAtIndex(index)
    }

    func removeAllCats() {
        self.cats.removeAll()
    }
}
