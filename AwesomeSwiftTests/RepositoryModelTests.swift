//
//  RepositoryTests.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 27/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import Nimble
import Quick
@testable import AwesomeSwift

class RepositoryModelTests: QuickSpec {
    override func spec() {

        let repo = RepositoryModel()
        let repoSecond = RepositoryModel()
        let jsonDummy: JSON = [
            "name": "repo",
            "descr": "description",
            "category": "cat1",
            "url": "http://"
        ]

        describe("a repository") {
            beforeEach() {
                repo.name = "test"
                repo.descr = "description"
                repo.category = "category"
                repo.url = "http://"

                repoSecond.name = "test2"
                repoSecond.descr = "description2"
                repoSecond.category = "category2"
                repoSecond.url = "http://2"
            }
            it("has name as primary key") {
                expect(RepositoryModel.primaryKey()).to(equal("name"))
            }
            it("not be nil") {
                expect(repo).toNot(beNil())
            }
            it("has a name") {
                expect(repo.name).to(equal("test"))
            }
            it("has a description") {
                expect(repo.descr).to(equal("description"))
            }
            it("has a category") {
                expect(repo.category).to(equal("category"))
            }
            it("has a url") {
                expect(repo.url).to(equal("http://"))
            }
            it("has createdAt") {
                expect(repo.createdAt).toNot(beNil())
            }
            context("map") {
                it("from json") {
                    repo.mapping(jsonDummy)
                    expect(repo.name).to(equal("repo"))
                    expect(repo.descr).to(equal("description"))
                    expect(repo.category).to(equal("cat1"))
                    expect(repo.url).to(equal("http://"))
                }
            }
            context("and another repository with different name") {
                it("are different") {
                    expect(repo).toNot(equal(repoSecond))
                }
            }
        }
    }
}
