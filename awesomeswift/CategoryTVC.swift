//
//  CategoryTVC.swift
//  awesomeswift
//
//  Created by Matteo Crippa on 23/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit
import Bond

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet var lblName : UILabel!
    
    /*func setupCell(repo: CategoryVM) {
        
        repo.name
            .bindTo(lblName.bnd_text)
    }*/
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
