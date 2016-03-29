//
//  RepositoryManagerTests.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 27/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import XCTest
import Nimble
import Quick
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
        let firstRepo = RepositoryModel()
        sut.addRepo(firstRepo)
        XCTAssertEqual(sut.repoCount, 1, "Adding one repo, repoCount should be 1")
        let secondRepo = RepositoryModel()
        sut.addRepo(secondRepo)
        XCTAssertEqual(sut.repoCount, 2, "Adding another one repo, repoCount should be 2")
    }

    func testRepositoryAtIndex_ShouldReturnPreviouslyAddedItem() {
        let firstRepo = RepositoryModel()
        firstRepo.name = "test"
        sut.addRepo(firstRepo)

        let returnedItem = sut.repoAtIndex(0)

        XCTAssertEqual(firstRepo.name, returnedItem!.name, "Should be the same repo")
    }

    func testRespositoryCount_AfterRemovingOneItem_IsZero() {
        let firstRepo = RepositoryModel()
        firstRepo.name = "test"
        sut.addRepo(firstRepo)
        sut.removeRepoAtIndex(0)

        XCTAssertEqual(sut.repoCount, 0, "Should be 0 repo")
    }

    func testRepositoryUniquenessCount_AddingRepoTwice_ShouldBeOne() {
        let firstRepo = RepositoryModel()
        firstRepo.name = "test1"
        sut.addRepo(firstRepo)
        sut.addRepo(firstRepo)

        XCTAssertEqual(sut.repoCount, 1, "Should be 1 repo")
    }

    func testRepositoryExtractOutOfRange_ShouldExtractNil() {
        let firstRepo = RepositoryModel()
        firstRepo.name = "test"
        sut.addRepo(firstRepo)

        let returnedItem = sut.repoAtIndex(1)

        XCTAssertNil(returnedItem)
    }

    func testRepositoryRemoveOutOfRange_ShouldNotExtract() {
        let firstRepo = RepositoryModel()
        firstRepo.name = "test"
        sut.addRepo(firstRepo)

        sut.removeRepoAtIndex(1)

        XCTAssertEqual(sut.repoCount, 1, "Should be 1 repo")
    }
}
