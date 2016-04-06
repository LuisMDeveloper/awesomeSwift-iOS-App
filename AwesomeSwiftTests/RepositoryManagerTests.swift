//
//  RepositoryManagerTests.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 27/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import Nimble
import Quick
@testable import AwesomeSwift

class RepositoryManagerTests: QuickSpec {
    override func spec() {
        var sut: RepositoryManager!

        var repo: RepositoryModel!

        beforeEach() {
            sut = RepositoryManager()

            repo = RepositoryModel()
            repo.name = "name"
            repo.category = "category"
            repo.url = "url"
            repo.descr = "description"
        }

        describe("repository manager") {
            it("manages RepositoryManager") {
                sut.itemAdd(repo)
                expect(repo).to(equal(sut.itemAt(0)))
                let test = sut.itemAt(0)
                expect(test).to(beAKindOf(RepositoryModel))
            }
        }
    }
}
