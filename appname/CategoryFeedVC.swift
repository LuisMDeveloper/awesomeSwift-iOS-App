//
//  CategoryFeedVC.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 02/06/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import DGElasticPullToRefresh_CanStartLoading
import LeeGo
import UIKit

class CategoryFeedVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private var elements = [AwesomeCategory]() {
        didSet {
            collectionView?.reloadData()
        }
    }
    private let api = API()
    private let categoryCellEstimatedHeight = CGFloat(40.0)

    override func awakeFromNib() {
        super.awakeFromNib()
        for reuseId in AwesomeCategoryBrick.reuseIdentifiers {
            collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // pull to refresh
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = .whiteColor()

        collectionView!.dg_addPullToRefreshWithActionHandler({ [unowned self] () -> Void in
                // update data
                self.api.getRepos() { json, error in
                    if error != nil {
                        log.error(error)
                    } else {
                        if let cats = json?["categories"].arrayValue {
                            self.elements = AwesomeCategory.categories(cats).sort({ $0.title.lowercaseString < $1.title.lowercaseString })
                            self.collectionView!.dg_stopLoading()
                        }
                    }

                }

                }, loadingView: loadingView)
        collectionView!.dg_setPullToRefreshFillColor(kAwesomeColor)
        collectionView!.dg_setPullToRefreshBackgroundColor(self.collectionView!.backgroundColor!)

        // swiftlint:disable force_cast
        (collectionView?.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = CGSizeMake(self.view.frame.width, categoryCellEstimatedHeight)

        // reload
        self.performSelector(#selector(CategoryFeedVC.updateWithLittleDelay), withObject: nil, afterDelay: 0.1)

    }

    func updateWithLittleDelay() {
        self.collectionView!.dg_startLoading()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension CategoryFeedVC {

    // MARK: Collection View DataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elements.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let catBrick = AwesomeCategoryBrick.Category.brick()

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(catBrick.name, forIndexPath: indexPath)

        cell.lg_configureAs(catBrick, dataSource: elements[indexPath.item], updatingStrategy: .Always)

        return cell
    }

    // MARK: Collection View Layout

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), categoryCellEstimatedHeight)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.5
    }

    // MARK: size
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ (context) -> Void in
            // swiftlint:disable force_cast
            (self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = CGSizeMake(self.view.frame.width, self.categoryCellEstimatedHeight)
            self.collectionView?.reloadData()
            }, completion: nil)

        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }

}

extension UICollectionViewCell {
    override public func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return lg_fittingHeightLayoutAttributes(layoutAttributes)
    }
}
