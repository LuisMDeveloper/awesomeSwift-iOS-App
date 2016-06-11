//
//  CreditsBrick.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 05/06/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import LeeGo
import UIKit

enum CreditsBrick: BrickBuilderType {
    case Text

    case Credits

    static let reuseIdentifiers = [Credits].map { component -> String in
        return component.brickName
    }

    static let brickClass: [CreditsBrick: AnyClass] = [
        Text: UILabel.self
    ]
}

extension CreditsBrick {
    func brick() -> Brick {
        switch self {
        case .Text:
            return build().style(Style.creditsStyle)
        case .Credits:
            return build()
                .style([.backgroundColor(UIColor.whiteColor())])
                .bricks(
                    Text.brick()
                ) {
                    (Text) in
                    Layout([
                        "V:|-8-[\(Text)]-8-|",
                        "H:|-8-[\(Text)]-8-|"
                        ])
            }
        }
    }
}
