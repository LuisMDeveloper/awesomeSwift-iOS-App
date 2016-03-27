//
//  CategoryTVC.swift
//  awesomeswift
//
//  Created by Matteo Crippa on 23/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!

    var cat: Category! = nil

    func configureWithModel(cat: Category) {
        self.cat = cat
        lblName.text = cat.name
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
