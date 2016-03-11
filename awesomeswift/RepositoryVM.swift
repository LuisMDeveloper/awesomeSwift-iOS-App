//
//  RepositoryVM.swift
//  awesomeswift
//
//  Created by Matteo Crippa on 10/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit
import SwiftDate
import Bond

protocol RepositoryVVM {
    var name: Observable<String> {get}
    var description: Observable<String> {get}
    var isNew: Observable<Bool> {get}
    var url: Observable<String> {get}
}

class RepositoryVVMFromRepository: RepositoryVVM {
    let repository: Repository
    
    let name: Observable<String>
    let description: Observable<String>
    let isNew: Observable<Bool>
    let url: Observable<String>
    
    init(_ repository: Repository){
        self.repository = repository
        
        self.name = Observable(repository.name)
        self.description = Observable(repository.descr)
        
        // force new if it is listed within the last 24h
        var isNew = true
        if repository.createdAt >  1.days.ago {
            isNew = false
        }
        
        self.isNew = Observable(isNew)
        self.url = Observable(repository.url)
    }
}