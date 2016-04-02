//
//  CategoryModelTests.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 27/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import Nimble
import Quick
import SwiftyJSON
@testable import AwesomeSwift

class CategoryModelTests: QuickSpec {
    override func spec() {

        let cat = CategoryModel()
        let jsonDummy: JSON = [
            "name": "cat1"
        ]

        describe("a category") {
            it("has a name") {
                let testName = "test"
                cat.name = testName
                expect(cat.name).to(equal(testName))
            }
            it("has name as primary key") {
                expect(CategoryModel.primaryKey()).to(equal("name"))
            }
            context("mapping") {
                it("from json") {
                    cat.mapping(jsonDummy)
                    expect(cat.name).to(equal("cat1"))
                }
            }
            context("and another category with the same name") {
                it("are the same category") {
                    let testName = "cat"
                    cat.name = testName
                    let testCat = CategoryModel()
                    testCat.name = testName
                    expect(cat.name).to(equal(testCat.name))
                }
            }
        }
    }
}
