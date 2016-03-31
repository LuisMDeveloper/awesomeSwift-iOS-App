//
//  RepositoryTests.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 27/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import Quick
import Nimble
@testable import AwesomeSwift

class RepositoryModelTests: QuickSpec {
    override func spec() {
        describe("a repository") {
            var repoFirst: RepositoryModel!
            var repoSecond: RepositoryModel!

            beforeEach() {
                repoFirst = RepositoryModel()
                repoFirst.name = "test"
                repoFirst.descr = "description"
                repoFirst.category = "category"
                repoFirst.url = "http://"

                repoSecond = RepositoryModel()
                repoSecond.name = "test2"
                repoSecond.descr = "description2"
                repoSecond.category = "category2"
                repoSecond.url = "http://2"
            }
            it("not be nil") {
                expect(repoFirst).toNot(beNil())
            }
            it("has a name") {
                expect(repoFirst.name).to(equal("test"))
            }
            it("has a description") {
                expect(repoFirst.descr).to(equal("description"))
            }
            it("has a category") {
                expect(repoFirst.category).to(equal("category"))
            }
            it("has a url") {
                expect(repoFirst.url).to(equal("http://"))
            }
            it("has createdAt") {
                expect(repoFirst.createdAt).toNot(beNil())
            }

            describe("and another repository with different name") {
                it("are different") {
                    expect(repoFirst).toNot(equal(repoSecond))
                }
            }
        }
    }
}
