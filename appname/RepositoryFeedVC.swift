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

    internal var elements = [AwesomeRepository]() {
        didSet {
            collectionView?.reloadData()
        }
    }
    private let repositoryCellEstimatedHeight = CGFloat(90.0)

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension RepositoryFeedVC {

    // TODO: add search filter

    // MARK: Collection View DataSource
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

        } else { // items
            let repoBrick = AwesomeRepositoryBrick.Repository.brick()
            let item = elements[indexPath.item]

            cell = collectionView.dequeueReusableCellWithReuseIdentifier(repoBrick.name, forIndexPath: indexPath)
            cell.lg_configureAs(repoBrick, dataSource: item, updatingStrategy: .Always)

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

    // MARK: Collection View Layout

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), repositoryCellEstimatedHeight)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.5
    }

    // MARK: Collection UICollectionViewDelegateFlowLayout
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    }

    // MARK: Collection cell size
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ (context) -> Void in
            // swiftlint:disable force_cast
            (self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = CGSizeMake(self.view.frame.width, self.repositoryCellEstimatedHeight)
            self.collectionView?.reloadData()
            }, completion: nil)

        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }

}
