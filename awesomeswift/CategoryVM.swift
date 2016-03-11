//
//  CategoryViewViewModel.swift
//  awesomeswift
//
//  Created by Matteo Crippa on 10/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit
import Bond

protocol CategoryVVM {
    var name: Observable<String> {get}
    var description: Observable<String> {get}
}

class CategoryVVMFromCategory: CategoryVVM {
    let category: Category
    
    let name: Observable<String>
    let description: Observable<String>
    
    init(_ category: Category){
        self.category = category
        
        self.name = Observable(category.name)
        
        let repos = category.repos.count
        
        var description  = "1 Repository"
        if repos > 1 {
            description = "\(repos) Repositories"
        }
        
        self.description = Observable(description)
        
    }
}