//
//  CategoryModelTests.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 27/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import Quick
import Nimble
@testable import AwesomeSwift

class CategoryModelTests: QuickSpec {
    override func spec() {
        describe("a category") {
            it("has a name") {
                let testName = "test"
                let cat = CategoryModel()
                cat.name = testName
                expect(cat.name).to(equal(testName))
            }

            describe("and another category with the same name") {
                it("are the same category") {
                    let testName = "cat"
                    let firstCat = CategoryModel()
                    firstCat.name = testName
                    let secondCat = CategoryModel()
                    secondCat.name = testName
                    expect(firstCat.name).to(equal(secondCat.name))
                }
            }
        }
    }
}
