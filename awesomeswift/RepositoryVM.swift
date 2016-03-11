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
    var name: String {get}
    var description: String {get}
    var isNew: Bool {get}
    var url: String {get}
}

class RepositoryVVMFromRepository: RepositoryVVM {
    let repository: Repository
    
    let name: String
    let description: String
    let isNew: Bool
    let url: String
    
    init(_ repository: Repository){
        self.repository = repository
        
        self.name = repository.name
        self.description = repository.descr
        
        // force new if it is listed within the last 24h
        var isNew = true
        if repository.createdAt >  1.days.ago {
            isNew = false
        }
        
        self.isNew = isNew
        self.url = repository.url
    }
}