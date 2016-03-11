//
//  CategoryViewViewModel.swift
//  awesomeswift
//
//  Created by Matteo Crippa on 10/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit

protocol CategoryVVM {
    var name: Dynamic<String> {get}
    var description: Dynamic<String> {get}
}

class CategoryVVMFromCategory: CategoryVVM {
    let category: Category
    
    let name: Dynamic<String>
    let description: Dynamic<String>
    
    init(_ category: Category){
        self.category = category
        
        self.name = Dynamic(category.name)
        
        let repos = category.repos.count
        
        var description  = "1 Repository"
        if repos > 1 {
            description = "\(repos) Repositories"
        }
        
        self.description = Dynamic(description)
        
    }
}