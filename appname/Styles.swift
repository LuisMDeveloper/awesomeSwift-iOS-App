//
//  Styles.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 02/06/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import LeeGo
import UIKit

let kAwesomeColor = UIColor(red: 247/255.0, green: 67/255.0, blue: 151/255.0, alpha: 1.0)

struct Style {

    static let titleBasicStyle: [Appearance] = [
        .backgroundColor(.whiteColor()),
        .textColor(.blackColor()),
        .font(UIFont.systemFontOfSize(14))
    ]

    static let descriptionBasicStyle: [Appearance] = [
        .text("description"),
        .backgroundColor(.whiteColor()),
        .textColor(.lightGrayColor()),
        .numberOfLines(0),
        .font(UIFont.systemFontOfSize(10))
    ]

    static let searchBarStyle: [Appearance] = [
        .backgroundColor(kAwesomeColor),
        .tintColor(kAwesomeColor),
        .custom(["barTintColor": kAwesomeColor])
    ]

    static let creditsStyle: [Appearance] = [
        .backgroundColor(.whiteColor()),
        .textColor(.blackColor()),
        .font(UIFont.systemFontOfSize(19)),
        .numberOfLines(0)
    ]

    static let buttonFavorite: [Appearance] = [
        .buttonImage(UIImage(named:"favorite")!, UIControlState.Normal),
        .tintColor(UIColor.lightGrayColor()),
        .custom(["imageRenderingMode": "template"]),
    ]

}

extension UIButton {
    public override func lg_setupCustomStyle(style: [String: AnyObject]) {
        if style.keys.first == "imageRenderingMode" {
            self.setImage(
                self.imageView?.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate),
                forState: .Normal
            )
        }
    }
}

extension UISearchBar {
    public override func lg_setupCustomStyle(style: [String: AnyObject]) {
        if style.keys.first == "barTintColor" {
            if let color = style.values.first as? UIColor {
                self.barTintColor = color
            }
        }
    }
}
