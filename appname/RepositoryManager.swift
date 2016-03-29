//
//  RepositoryManager.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 27/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit
import RealmSwift

class RepositoryManager {

    private var repos = [RepositoryModel]()
    private let realm = RealmProvider.realm()

    var repoCount: Int {
        return repos.count
    }

    init() {
        updateFromRealm()
    }

    private func updateFromRealm() {
        // swiftlint:disable force_try
        repos = Array(try! Realm().objects(RepositoryModel))
    }

    func addRepo(repo: RepositoryModel) {
        if !repos.contains(repo) {
            repos.append(repo)
            // swiftlint:disable force_try
            try! realm.write {
                realm.add(repo)
            }
        }
    }

    func repoAtIndex(index: Int) -> RepositoryModel? {
        let upperBound = repos.count
        if 0..<upperBound ~= index {
            return repos[index]
        } else {
            return nil
        }
    }

    func removeRepoAtIndex(index: Int) {
        let upperBound = repos.count
        if 0..<upperBound ~= index {
            let repo = repos[index]
            repos.removeAtIndex(index)
            // swiftlint:disable force_try
            try! realm.write {
                realm.delete(repo)
            }
        }
    }

    func removeAllRepos() {
        repos.removeAll()
        // swiftlint:disable force_try
        try! realm.write {
            realm.deleteAll()
        }
    }

}
