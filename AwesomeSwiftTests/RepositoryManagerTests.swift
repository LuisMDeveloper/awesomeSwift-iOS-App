//
//  RepositoryManagerTests.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 27/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import Nimble
import Quick
import RealmSwift
@testable import AwesomeSwift

class RepositoryManagerTests: QuickSpec {
    override func spec() {
        var sut: RepositoryManager!

        var realm: Realm!

        var firstRepo: RepositoryModel!
        var secondRepo: RepositoryModel!

        beforeEach() {
            sut = RepositoryManager()

            realm = RealmProvider.realm()
            // swiftlint:disable force_try
            try! realm.write {
                realm.deleteAll()
            }

            firstRepo = RepositoryModel()
            firstRepo.name = "name"
            firstRepo.category = "category"
            firstRepo.url = "url"
            firstRepo.descr = "description"

            secondRepo = RepositoryModel()
            secondRepo.name = "name"
            secondRepo.category = "category"
            secondRepo.url = "url"
            secondRepo.descr = "description"
        }

        describe("a repository manager") {
            it("have 0 repo once initialized") {
                expect(sut.repoCount).to(equal(0))
                expect(realm.objects(RepositoryModel).count).to(equal(0))
            }
            it("have 1 repo once one added") {
                sut.addRepo(firstRepo)
                expect(sut.repoCount).to(equal(1))
                expect(realm.objects(RepositoryModel).count).to(equal(1))
            }
            it("return item once requested") {
                sut.addRepo(firstRepo)
                let repo = sut.repoAtIndex(0)
                expect(repo).notTo(beNil())
                expect(sut.repoCount).to(equal(1))
                expect(realm.objects(RepositoryModel).count).to(equal(1))
           }
            it("have 0 repo if you remove one") {
                sut.addRepo(firstRepo)
                expect(sut.repoCount).to(equal(1))
                expect(realm.objects(RepositoryModel).count).to(equal(1))
                sut.removeRepoAtIndex(0)
                expect(sut.repoCount).to(equal(0))
                expect(realm.objects(RepositoryModel).count).to(equal(0))
            }
            it("have 0 repo if you remove all") {
                sut.addRepo(firstRepo)
                sut.addRepo(secondRepo)
                expect(sut.repoCount).to(equal(2))
                expect(realm.objects(RepositoryModel).count).to(equal(2))
                sut.removeAllRepos()
                expect(sut.repoCount).to(equal(0))
                expect(realm.objects(RepositoryModel).count).to(equal(0))
            }
            it("doesn't get repo out of range") {
                sut.addRepo(firstRepo)
                let repo = sut.repoAtIndex(5)
                expect(repo).to(beNil())
            }
            it("doesn't remove repo out of range") {
                sut.addRepo(firstRepo)
                sut.removeRepoAtIndex(5)
                expect(sut.repoCount).to(equal(1))
                expect(realm.objects(RepositoryModel).count).to(equal(1))
            }
        }
    }
}
