//
//  RepositoryCell.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 16/04/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit

protocol RepositoryCellDelegate {
    func tappedFavorite(repo: RepositoryModel)
}

class RepositoryCell: UITableViewCell {

    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var lblName: UILabel!

    var repo: RepositoryModel!
    var delegate: RepositoryCellDelegate?


    @IBAction func tappedStar(sender: UIButton) {

        //repo.favorite = !repo.favorite

        btnFavorite.selected = !repo.favorite
        delegate?.tappedFavorite(repo)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }

    func configCellWithRepository(repo: RepositoryModel) {

        self.repo = repo

        lblName.text = repo.name

        btnFavorite.tag = self.tag
        btnFavorite.selected = repo.favorite
    }

}
