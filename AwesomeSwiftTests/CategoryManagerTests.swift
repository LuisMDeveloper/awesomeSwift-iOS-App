//
//  CategoryManagerTests.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 27/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import Nimble
import Quick
@testable import AwesomeSwift

class CategoryManagerTests: QuickSpec {
    override func spec() {
        var sut: CategoryManager!

        var cat: CategoryModel!
        
        beforeEach() {
            sut = CategoryManager()

            cat = CategoryModel()
            cat.name = "name"
        }

        describe("category manager") {
            it("manages CategoryModel") {
                sut.itemAdd(cat)
                expect(cat).to(equal(sut.itemAt(0)))
                let test = sut.itemAt(0)
                expect(test).to(beAKindOf(CategoryModel))
            }
        }
    }
}
