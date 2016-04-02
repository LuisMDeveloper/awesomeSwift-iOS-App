//
//  RepositoryTests.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 27/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import Quick
import Nimble
import SwiftyJSON
@testable import AwesomeSwift

class RepositoryModelTests: QuickSpec {
    override func spec() {
        describe("a repository") {
            var repoFirst: RepositoryModel!
            var repoSecond: RepositoryModel!
            let jsonDummy: JSON = [
                "name": "repo",
                "descr": "description",
                "category": "cat1",
                "url": "http://"
            ]

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
            it("has name as primary key") {
                expect(RepositoryModel.primaryKey()).to(equal("name"))
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
            context("map") {
                it("from json") {
                    let repoJson = RepositoryModel()
                    repoJson.mapping(jsonDummy)
                    expect(repoJson.name).to(equal("repo"))
                    expect(repoJson.descr).to(equal("description"))
                    expect(repoJson.category).to(equal("cat1"))
                    expect(repoJson.url).to(equal("http://"))
                }
            }
            context("and another repository with different name") {
                it("are different") {
                    expect(repoFirst).toNot(equal(repoSecond))
                }
            }
        }
    }
}
