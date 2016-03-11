//
//  CategoryViewViewModel.swift
//  awesomeswift
//
//  Created by Matteo Crippa on 10/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit

protocol CategoryVVM {
    var category: Category {get}
    var name: String {get}
    var description: String {get}
}

class CategoryVVMFromCategory: CategoryVVM {
    let category: Category
    
    let name: String
    let description: String
    
    init(_ category: Category){
        self.category = category
        
        self.name = category.name
        
        let repos = category.repos.count
        
        var description  = "1 Repository"
        if repos > 1 {
            description = "\(repos) Repositories"
        }
        
        self.description = description
        
    }
}