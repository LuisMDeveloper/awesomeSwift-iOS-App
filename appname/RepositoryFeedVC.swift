//
//  RepositoryFeedVC.swift
//  awesomeswift
//
//  Created by Matteo Crippa on 02/06/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import DGElasticPullToRefresh_CanStartLoading
import LeeGo
import SafariServices
import SwiftyUserDefaults
import UIKit

class RepositoryFeedVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    internal var fromCategory = false
    internal var repositories = [AwesomeRepository]()
    internal var elements = [AwesomeRepository]() {
        didSet {
            // force reload only repositories
            collectionView?.reloadSections(NSIndexSet(index: 1))
        }
    }
    internal let repositoryCellEstimatedHeight = CGFloat(38.0)

    override func awakeFromNib() {
        super.awakeFromNib()
        for reuseId in AwesomeRepositoryBrick.reuseIdentifiers {
            collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
        }

        for reuseId in AwesomeRepositoryBrick.reuseSearchIdentifiers {
            collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // styling
        collectionView?.backgroundColor = .whiteColor()

        // swiftlint:disable force_cast
        (collectionView?.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = CGSizeMake(self.view.frame.width, repositoryCellEstimatedHeight)

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // manage favorites
        if fromCategory == false {
            self.title = "Favorites"

            self.repositories = AwesomeRepository
                .repositories(awesomeJSON!["projects"].arrayValue)
                .sort({ $0.title.lowercaseString < $1.title.lowercaseString })
                .filter({ Defaults[.Favorites].contains($0.title) })
        }

        elements = repositories
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

// MARK: Collection View DataSource
extension RepositoryFeedVC {

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return elements.count
        }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        var cell: UICollectionViewCell

        // search
        if indexPath.section == 0 {
            let searchBrick = AwesomeRepositoryBrick.Search.brick()

            cell = collectionView.dequeueReusableCellWithReuseIdentifier(searchBrick.name, forIndexPath: indexPath)
            cell.lg_configureAs(searchBrick, dataSource: nil, updatingStrategy: .Always)

            // set handlers
            if let searchBar = cell.lg_viewForOutletKey(AwesomeRepositoryBrick.SearchBar.brickName) as? UISearchBar {
                searchBar.delegate = self
            }

        } else { // items
            let repoBrick = AwesomeRepositoryBrick.Repository.brick()
            let item = elements[indexPath.item]

            cell = collectionView.dequeueReusableCellWithReuseIdentifier(repoBrick.name, forIndexPath: indexPath)
            cell.lg_configureAs(repoBrick, dataSource: item, updatingStrategy: .Always)

            // set handlers
            if let favoriteBtn = cell.lg_viewForOutletKey(AwesomeRepositoryBrick.Favorite.brickName) as? UIButton {
                favoriteBtn.tag = indexPath.item
                favoriteBtn.addTarget(
                    self,
                    action: #selector(favoriteUpdate(_:)),
                    forControlEvents: .TouchUpInside
                )

            }

        }

        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), repositoryCellEstimatedHeight)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.5
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let repo = repositories[indexPath.row]

        // open browser
        if let requestUrl = NSURL(string: repo.homepage) {
            let sfvc = SFSafariViewController.init(URL: requestUrl)

            self.showViewController(sfvc, sender: self)

        }

    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ (context) -> Void in
            // swiftlint:disable force_cast
            (self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = CGSizeMake(self.view.frame.width, self.repositoryCellEstimatedHeight)
            self.collectionView?.reloadData()
            }, completion: nil)

        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }

}

// MARK: Favorite Button
extension RepositoryFeedVC {
    func favoriteUpdate(btn: UIButton) {
        btn.selected = !btn.selected

        let item = elements[btn.tag]

        if btn.selected {
            btn.shake(toward: .Top, amount: 0.2, duration: 1, delay: 0)
            btn.tintColor = kAwesomeColor
            log.debug("Favorite Add \(item.title)")
            if Defaults[.Favorites].contains(item.title) == false {
                Defaults[.Favorites].append(item.title)
            }
        } else {
            btn.shake(toward: .Bottom, amount: 0.2, duration: 1, delay: 0)
            btn.tintColor = UIColor.lightGrayColor()
            log.debug("Favorite Remove \(item.title)")
            if Defaults[.Favorites].contains(item.title) == true {
                Defaults[.Favorites].removeAtIndex(Defaults[.Favorites].indexOf(item.title)!)
            }
        }

    }
}

// MARK: SearchBar
extension RepositoryFeedVC: UISearchBarDelegate {

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count > 0 {

            elements = repositories
                .sort({ $0.title.lowercaseString < $1.title.lowercaseString })
                .filter({
                    $0.title.lowercaseString.rangeOfString(searchText.lowercaseString) != nil  ||
                    $0.description.lowercaseString.rangeOfString(searchText.lowercaseString) != nil
                })

        } else {
            elements = repositories
        }

    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
