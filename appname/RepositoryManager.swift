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

    var repoCount: Int {
        return self.repos.count
    }

    init() {
        self.updateFromRealm()
    }

    private func updateFromRealm() {
        // swiftlint:disable force_try
        self.repos = Array(try! Realm().objects(RepositoryModel))
    }

    func addRepo(repo: RepositoryModel) {
        if !self.repos.contains(repo) {
            self.repos.append(repo)
        }
    }

    func removeRepoAtIndex(index: Int) {
        let upperBound = self.repos.count
        if ( index >= 0 && index < upperBound ) {
            self.repos.removeAtIndex(index)
        }
    }

    func removeAllRepos() {
        self.repos.removeAll()
    }

    func repoAtIndex(index: Int) -> RepositoryModel? {
        let upperBound = self.repos.count
        if ( index >= 0 && index < upperBound) {
            return self.repos[index]
        } else {
            return nil
        }
    }

}
