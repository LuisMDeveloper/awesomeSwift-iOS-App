//
//  Styles.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 02/06/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import LeeGo
import UIKit

struct Style {
    static let titleBasicStyle: [Appearance] = [
        .backgroundColor(.whiteColor()),
        .font(UIFont.systemFontOfSize(14))
    ]

    static let descriptionBasicStyle: [Appearance] = [
        .text("description"),
        .backgroundColor(.whiteColor()),
        .textColor(.lightGrayColor()),
        .numberOfLines(0),
        .font(UIFont.systemFontOfSize(10))
    ]

    static let blocksStyle: [Appearance] = [.backgroundColor(UIColor(red: 0.945, green: 0.769, blue: 0.0588, alpha: 1)), .cornerRadius(3)]
    static let redBlockStyle: [Appearance] = [.backgroundColor(UIColor(red: 0.906, green: 0.298, blue: 0.235, alpha: 1)), .cornerRadius(3)]
    static let greenBlockStyle: [Appearance] = [.backgroundColor(UIColor(red: 0.18, green: 0.8, blue: 0.443, alpha: 1)), .cornerRadius(3)]
    static let blueBlockStyle: [Appearance] = [.backgroundColor(UIColor(red: 0.204, green: 0.596, blue: 0.859, alpha: 1)), .cornerRadius(3)]

}
