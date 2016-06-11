//
//  RepositoryBrick.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 02/06/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import LeeGo
import UIKit

enum AwesomeRepositoryBrick: BrickBuilderType {
    case Title, Description, Favorite
    case LineBreak

    case SearchBar

    case Search, Repository

    static let reuseIdentifiers = [Repository].map { component -> String in
        return component.brickName
    }

    static let reuseSearchIdentifiers = [Search].map { component -> String in
        return component.brickName
    }

    static let brickClass: [AwesomeRepositoryBrick: AnyClass] = [
        Title: UILabel.self,
        Description: UILabel.self,
        Favorite: UIButton.self,
        LineBreak: UIView.self,
        SearchBar: UISearchBar.self
    ]
}

extension AwesomeRepositoryBrick {
    func brick() -> Brick {
        switch self {
        case .Title:
            return build()
                .style(Style.titleBasicStyle)
        case .Description:
            return build()
                .style(Style.descriptionBasicStyle)
        case .Favorite:
            return build()
                .style(Style.buttonFavorite)
                .height(28)
                .width(28)
                .LGOutlet("Favorite")
        case .LineBreak:
            return build()
                .height(1)
                .style([
                    .backgroundColor(kAwesomeColor)
                ])
        case .SearchBar:
            return build()
                .style(Style.searchBarStyle)
                .height(44)
                .LGOutlet("SearchBar")
        case .Search:
            return build()
                .bricks(
                    SearchBar.brick()
                ) {
                    (SearchBar) in
                    Layout([
                        "V:|[\(SearchBar)]|",
                        "H:|[\(SearchBar)]|"
                        ])
            }
        case .Repository:
            return build()
                .style([
                    .backgroundColor(UIColor.whiteColor())
                ])
                .bricks(
                    Favorite.brick(),
                    Title.brick(),
                    Description.brick(),
                    LineBreak.brick()
                ) {
                    (Favorite, Title, Description, LineBreak) in
                    Layout([
                        "V:|-[\(Title)]-[\(Description)]-[\(LineBreak)]|",
                        "H:|-[\(Favorite)]-[\(Title)]-|",
                        "H:|-44-[\(Description)]-|",
                        "H:|[\(LineBreak)]|"
                        ])
            }
        }
    }
}
