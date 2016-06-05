//
//  AwesomeRepository.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 02/06/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit

import SimpleAnimation
import LeeGo
import SwiftyUserDefaults
import SwiftyJSON

struct AwesomeRepository {
    let title: String
    let category: String
    let description: String
    let homepage: String

    init(json: JSON) {
        title = json["title"].stringValue
        category = json["category"].stringValue
        description = json["description"].stringValue
        homepage = json["homepage"].stringValue
    }
}

extension AwesomeRepository {
    static func repositories(jsonArray: [JSON]) -> [AwesomeRepository] {
        return jsonArray.map({
            json -> AwesomeRepository in
            return AwesomeRepository(json: json)
        })
    }
}

extension AwesomeRepository: BrickDataSource {
    func update(targetView: UIView, with brick: Brick) {
        switch targetView {
        case let label as UILabel where brick == AwesomeRepositoryBrick.Title:
            label.text = title
        case let button as UIButton where brick == AwesomeRepositoryBrick.Favorite:
            if Defaults[.Favorites].contains(title) {
                button.selected = true
                button.tintColor = kAwesomeColor
            }
        case let label as UILabel where brick == AwesomeRepositoryBrick.Description:
            label.text = description
        default:
            break
        }
    }
}
