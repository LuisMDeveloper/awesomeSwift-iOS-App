//
//  CreditsVC.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 05/06/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import SwiftyMarkdown
import UIKit

class CreditsVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private var elements = [Credits]() {
        didSet {
            collectionView?.reloadData()
        }
    }
    private let creditCellEstimatedHeight = CGFloat(200.0)

    override func awakeFromNib() {
        super.awakeFromNib()
        for reuseId in CreditsBrick.reuseIdentifiers {
            collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let text = "# AwesomeSwift App\n\n" +
        "This app is powered by developers of libraries that share their job releasing open source projects on Github.\n\n" +
        "If you want to add a new library, feel free to contribute with a **Pull Request** at https://github.com/matteocrippa/awesome-swift\n\n\n" +
        "This app makes use of these *awesome libraries*:\n\n" +
        " - DGEElasticPullToRefresh\n" +
        " - Fabric\n" +
        " - Fastlane tools\n" +
        " - Moya\n" +
        " - Nimble\n" +
        " - Quick\n" +
        " - RAMAnimatedTabBarController\n" +
        " - SwiftyDate\n" +
        " - SwiftyMarkdown\n" +
        " - SwiftyJSON\n" +
        " - SwiftyUserDefaults\n"

        // elements
        elements = Credits.credits([text])

        // styling
        collectionView?.backgroundColor = .whiteColor()

        // swiftlint:disable force_cast
        (collectionView?.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = CGSizeMake(self.view.frame.width, creditCellEstimatedHeight)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension CreditsVC {

    // MARK: Collection View DataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elements.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let creditsBrick = CreditsBrick.Credits.brick()

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(creditsBrick.name, forIndexPath: indexPath)

        cell.lg_configureAs(creditsBrick, dataSource: elements[indexPath.item], updatingStrategy: .Always)

        return cell
    }

    // MARK: Collection UICollectionViewDelegateFlowLayout
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
       // self.performSegueWithIdentifier("showRepos", sender: collectionView.cellForItemAtIndexPath(indexPath))
    }


    // MARK: Collection View Layout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), creditCellEstimatedHeight)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.5
    }

    // MARK: Cell Size
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ (context) -> Void in
            // swiftlint:disable force_cast
            (self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = CGSizeMake(self.view.frame.width, self.creditCellEstimatedHeight)
            self.collectionView?.reloadData()
            }, completion: nil)

        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }

}
