//
//  RepositoryCell.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 16/04/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit

class RepositoryCell: UITableViewCell {

    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var lblName: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configCellWithRepository(repo: RepositoryModel) {
        lblName.text = repo.name
        btnFavorite.selected = rand() % 2 == 0 ? true : false
    }

}
