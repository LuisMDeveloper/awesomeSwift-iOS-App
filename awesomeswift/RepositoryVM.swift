//
//  RepositoryVM.swift
//  awesomeswift
//
//  Created by Matteo Crippa on 10/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit
import SwiftDate

protocol RepositoryVVM {
    var name: Dynamic<String> {get}
    var description: Dynamic<String> {get}
    var isNew: Dynamic<Bool> {get}
    var url: Dynamic<String> {get}
}

class RepositoryVVMFromRepository: RepositoryVVM {
    let repository: Repository
    
    let name: Dynamic<String>
    let description: Dynamic<String>
    let isNew: Dynamic<Bool>
    let url: Dynamic<String>
    
    init(_ repository: Repository){
        self.repository = repository
        
        self.name = Dynamic(repository.name)
        self.description = Dynamic(repository.descr)
        
        // force new if it is listed within the last 24h
        var isNew = true
        if repository.createdAt >  1.days.ago {
            isNew = false
        }
        
        self.isNew = Dynamic(isNew)
        self.url = Dynamic(repository.url)
    }
}