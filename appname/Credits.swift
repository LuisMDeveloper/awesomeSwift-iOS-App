//
//  Credits.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 05/06/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import LeeGo
import SwiftyMarkdown

struct Credits {
    let text: String

    init(txt: String) {
        text = txt
    }
}

extension Credits {
    static func credits(lines: [String]) -> [Credits] {
        return lines.map({
            text -> Credits in
            return Credits(txt: text)
        })
    }
}

extension Credits: BrickDataSource {
    func update(targetView: UIView, with brick: Brick) {
        switch targetView {
        case let label as UILabel where brick == CreditsBrick.Text:
            let md = SwiftyMarkdown(string: text)
            label.attributedText = md.attributedString()
        default:
            break
        }
    }
}
