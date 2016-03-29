//
//  CategoryManagerTests.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 27/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import Nimble
import Quick
import RealmSwift
@testable import AwesomeSwift

class CategoryManagerTests: QuickSpec {
    override func spec() {

        var sut: CategoryManager!

        var realm: Realm!

        var firstCat: CategoryModel!
        var secondCat: CategoryModel!

        beforeEach() {
            sut = CategoryManager()

            realm = RealmProvider.realm()
            // swiftlint:disable force_try
            try! realm.write {
                realm.deleteAll()
            }

            firstCat = CategoryModel()
            firstCat.name = "first"

            secondCat = CategoryModel()
            secondCat.name = "second"
        }

        describe("a category manager") {
            it("have 0 cat once initialized") {
                expect(sut.catCount).to(equal(0))
                expect(realm.objects(CategoryModel).count).to(equal(0))
            }
            it("have 1 cat once first added") {
                sut.addCat(firstCat)
                expect(sut.catCount).to(equal(1))
                expect(realm.objects(CategoryModel).count).to(equal(1))
            }
            it("return item once request") {
                sut.addCat(firstCat)
                expect(sut.catAtIndex(0)!.name).to(equal("first"))
                expect(realm.objects(CategoryModel).count).to(equal(1))
            }
            it("have 0 cat removing a category") {
                sut.addCat(firstCat)
                expect(sut.catCount).to(equal(1))
                sut.removeCatAtIndex(0)
                expect(sut.catCount).to(equal(0))
            }
            it("have 0 cats after removing all cats") {
                sut.addCat(firstCat)
                sut.addCat(secondCat)
                expect(sut.catCount).to(equal(2))
                expect(realm.objects(CategoryModel).count).to(equal(2))
                sut.removeAllCats()
                expect(sut.catCount).to(equal(0))
                expect(realm.objects(CategoryModel).count).to(equal(0))
            }
            it("checks for uniqueness adding new cat") {
                sut.addCat(firstCat)
                sut.addCat(firstCat)
                expect(sut.catCount).to(equal(1))
                expect(realm.objects(CategoryModel).count).to(equal(1))
            }
            it("doesn't get category out of range") {
                sut.addCat(firstCat)
                let cat = sut.catAtIndex(5)
                expect(cat).to(beNil())
            }
            it("doesn't delete category out of range") {
                sut.addCat(firstCat)
                sut.removeCatAtIndex(5)
                expect(sut.catCount).to(equal(1))
                expect(realm.objects(CategoryModel).count).to(equal(1))
            }
        }
    }
}
