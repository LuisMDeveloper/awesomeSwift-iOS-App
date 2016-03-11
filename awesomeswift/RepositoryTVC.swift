//
//  RepoTableViewCell.swift
//  awesomeswift
//
//  Created by Matteo Crippa on 24/01/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit
import Bond

class RepoTableViewCell: UITableViewCell {
    
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblDescription : UILabel!
    
    @IBOutlet var badgeIsNew : UIView!
    
    var viewModel: RepositoryVVM? {
        didSet {
            
            viewModel?.name.observe{
                name in
                self.lblName.text = name
            }
            
            viewModel?.description.observe{
                description in
                self.lblDescription.text = description
                
            }
            
            viewModel?.isNew.observe{
                isNew in
                self.badgeIsNew.hidden = isNew
                
            }
            
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
