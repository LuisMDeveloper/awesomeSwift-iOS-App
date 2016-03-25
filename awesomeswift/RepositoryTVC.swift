//
//  RepoTableViewCell.swift
//  awesomeswift
//
//  Created by Matteo Crippa on 24/01/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit
import SwiftDate

class RepoTableViewCell: UITableViewCell {
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var badgeIsNew: UIView!
    
    var repo: Repository! = nil
    
    func configureWithModel(repo: Repository) {
        self.repo = repo
        lblName.text = repo.name
        lblDescription.text = repo.descr
        var isNew = true
        if repo.createdAt >  1.days.ago {
            isNew = false
        }
        badgeIsNew.hidden = !isNew

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
