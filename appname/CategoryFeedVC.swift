//
//  CategoryFeedVC.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 02/06/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import DGElasticPullToRefresh_CanStartLoading
import LeeGo
import SwiftyJSON
import SwiftyUserDefaults
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

        // styling
        collectionView?.backgroundColor = .whiteColor()

        // pull to refresh
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = .whiteColor()

        self.performSelector(#selector(CategoryFeedVC.updateWithLittleDelay), withObject: nil, afterDelay: 0.1)

        collectionView!.dg_addPullToRefreshWithActionHandler({ [unowned self] () -> Void in
                // update data
                self.api.getRepos() { json, error in
                    if error != nil {
                        log.error(error)
                    } else {
                        awesomeJSON = json
                        if let cats = json?["categories"].arrayValue {
                            self.elements = AwesomeCategory.categories(cats).sort({ $0.title.lowercaseString < $1.title.lowercaseString })
                            //Defaults[.categories] = self.elements
                            self.collectionView!.dg_stopLoading()
                        }
                    }

                }

                }, loadingView: loadingView)
        collectionView!.dg_setPullToRefreshFillColor(kAwesomeColor)
        collectionView!.dg_setPullToRefreshBackgroundColor(self.collectionView!.backgroundColor!)

        // swiftlint:disable force_cast
        (collectionView?.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = CGSizeMake(self.view.frame.width, categoryCellEstimatedHeight)


    }

    func updateWithLittleDelay() {
        self.collectionView!.dg_startLoading()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRepos" {

            let vc: RepositoryFeedVC = segue.destinationViewController as! RepositoryFeedVC
            let cell = sender as! UICollectionViewCell
            let indexPath = collectionView!.indexPathForCell(cell)
            let catSelected = self.elements[indexPath!.row]
            vc.title = catSelected.title
            
            vc.fromCategory = true

            vc.repositories = AwesomeRepository
                .repositories(awesomeJSON!["projects"].arrayValue)
                .sort({ $0.title.lowercaseString < $1.title.lowercaseString })
                .filter({ $0.category == catSelected.id })

            log.debug(vc.elements)

        }
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

    // MARK: Collection UICollectionViewDelegateFlowLayout
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showRepos", sender: collectionView.cellForItemAtIndexPath(indexPath))
    }


    // MARK: Collection View Layout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), categoryCellEstimatedHeight)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.5
    }

    // MARK: Cell Size
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ (context) -> Void in
            // swiftlint:disable force_cast
            (self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = CGSizeMake(self.view.frame.width, self.categoryCellEstimatedHeight)
            self.collectionView?.reloadData()
            }, completion: nil)

        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }

}
