//
//  RepositoryVM.swift
//  awesomeswift
//
//  Created by Matteo Crippa on 10/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit
import SwiftDate
import RxSwift
import RxRealm
import RealmSwift
import Log


struct RepositoryViewModel {
    let repos = BehaviorSubject<[Repository]>(value: [])
    private let disposeBag = DisposeBag()
    
    func filter(filter: String) {
        Realm
            .rx_objects(Repository)
            .map { results -> [Repository] in
                return results.map { $0 }
            }
            .bindNext { xs in
                self.repos.on(.Next(xs.filter { $0.name.hasPrefix(filter) }))
            }
            .addDisposableTo(disposeBag)
    }
    
    func update() {
        Realm
            .rx_objects(Repository)
            .map{ results -> [Repository] in
                //Log.debug(results)
                Log.debug(results.count)
                return results.map { $0 }
            }
            .bindNext { xs in
                self.repos.on(.Next(xs))
            }
            .addDisposableTo(disposeBag)
    }
}


/*protocol RepositoryVVM {
    var name: Variable<String> {get}
    var description: Variable<String> {get}
    var isNew: Variable<Bool> {get}
    var url: Variable<String> {get}
}

class RepositoryVVMFromRepository: RepositoryVVM {
    let repository: Repository
    
    let name: Variable<String>
    let description: Variable<String>
    let isNew: Variable<Bool>
    let url: Variable<String>
    
    init(_ repository: Repository){
        self.repository = repository
        
        self.name = Variable(repository.name)
        self.description = Variable(repository.descr)
        
        // force new if it is listed within the last 24h
        var isNew = true
        if repository.createdAt >  1.days.ago {
            isNew = false
        }
        
        self.isNew = Variable(isNew)
        self.url = Variable(repository.url)
    }
}*/