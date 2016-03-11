//
//  RepoTableViewCell.swift
//  awesomeswift
//
//  Created by Matteo Crippa on 24/01/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit

class RepoTableViewCell: UITableViewCell {
    
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblDescription : UILabel!
    
    @IBOutlet var badgeIsNew : UIView!
    
    var viewModel: RepositoryVVM? {
        didSet {
            lblName.text = viewModel?.name
            lblDescription.text = viewModel?.description
            
            badgeIsNew.hidden = !(viewModel?.isNew)!
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
