//
//  RepositoryManagerTests.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 27/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import XCTest
@testable import AwesomeSwift

class RepositoryManagerTests: XCTestCase {

    var sut: RepositoryManager!

    override func setUp() {
        super.setUp()
        let realm = RealmProvider.realm()
        // swiftlint:disable force_try
        try! realm.write {
            realm.deleteAll()
        }
        sut = RepositoryManager()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testRepositoryCount_Initially_ShouldBeZero() {
        XCTAssertEqual(sut.repoCount, 0, "Initially repo count should be 0")
    }

    func testRepositoryCount_AfterAddingOneItem_IsOne() {
        let repo = RepositoryModel()
        sut.addRepo(repo)
        XCTAssertEqual(sut.repoCount, 1, "Adding one repo, repoCount should be 1")
    }

    func testRepositoryAtIndex_ShouldReturnPreviouslyAddedItem() {
        let repo = RepositoryModel()
        repo.name = "test"
        sut.addRepo(repo)

        let returnedItem = sut.repoAtIndex(0)

        XCTAssertEqual(repo.name, returnedItem.name, "Should be the same repo")
    }

    func testRespositoryCount_AfterRemovingOneItem_IsZero() {
        let repo = RepositoryModel()
        repo.name = "test"
        sut.addRepo(repo)
        sut.removeRepoAtIndex(0)

        XCTAssertEqual(sut.repoCount, 0, "Should be 0 repo")
    }

    func testRepositoryUniquenessCount_AddingRepoTwice_ShouldBeOne() {
        let firstRepo = RepositoryModel()
        firstRepo.name = "test1"
        sut.addRepo(firstRepo)
        let secondRepo = RepositoryModel()
        secondRepo.name = "test1"
        sut.addRepo(secondRepo)

        XCTAssertEqual(sut.repoCount, 1, "Should be 1 repo")
    }
}
