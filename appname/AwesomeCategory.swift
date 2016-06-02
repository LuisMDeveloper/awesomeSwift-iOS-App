//
//  CategoryJson.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 02/06/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import LeeGo
import SwiftyJSON
import UIKit

struct AwesomeCategory {
    let title: String
    let id: String
    let description: String

    init(json: JSON) {
        title = json["title"].stringValue
        id = json["id"].stringValue
        description = json["description"].stringValue
    }
}

extension AwesomeCategory {
    static func categories(jsonArray: [JSON]) -> [AwesomeCategory] {
        return jsonArray.map({
            json -> AwesomeCategory in
            return AwesomeCategory(json: json)
        })
    }
}

extension AwesomeCategory: BrickDataSource {
    func update(targetView: UIView, with brick: Brick) {
        switch targetView {
        case let label as UILabel where brick == AwesomeCategoryBrick.Title:
            label.text = title
        case let label as UILabel where brick == AwesomeCategoryBrick.Description:
            label.text = description
        default:
            break
        }
    }
}
