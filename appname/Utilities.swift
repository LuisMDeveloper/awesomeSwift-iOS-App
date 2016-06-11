//
//  Utilities.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 17/04/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import LeeGo
import SafariServices
import SwiftyUserDefaults
import UIKit

protocol BrickConvertible {
    func brick() -> Brick
}

// MARK: - Defaults
extension DefaultsKeys {
    static let Categories = DefaultsKey<[AwesomeCategory]?>("categories")
    static let Favorites = DefaultsKey<[String]>("favorites")
}

extension NSUserDefaults {
    subscript(key: DefaultsKey<[AwesomeCategory]?>) -> [AwesomeCategory]? {
        get { return unarchive(key) }
        set { archive(key, newValue) }
    }
}

// MARK: - Safari
extension SFSafariViewController {

    override public func previewActionItems() -> [UIPreviewActionItem] {

        let deleteAction =  UIPreviewAction(title: "Cancel",
                                            style: UIPreviewActionStyle.Destructive,
                                            handler: {
                                                (previewAction, viewController) in

                                                log.debug("Delete")

        })


        return [deleteAction]
    }

}

extension UITableView {
    func deselectSelectedRow() {
        if let selected = self.indexPathForSelectedRow {
            self.deselectRowAtIndexPath(selected, animated: false)
        }
    }
}

extension UIScrollView {
    func dg_stopScrollingAnimation() {}
}

extension UICollectionViewCell {
    override public func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return lg_fittingHeightLayoutAttributes(layoutAttributes)
    }
}

// UIButton
extension UIButton {

    private func setOrTriggerClosure(closure:((button: UIButton) -> Void)? = nil) {

        // swiftlint:disable type_name
        struct __ {
            static var closure :((button: UIButton) -> Void)?
        }

        //if closure has been passed in, set the struct to use it
        if closure != nil {
            __.closure = closure
        } else {
            //otherwise trigger the closure
            __.closure?(button: self)
        }
    }
    @objc private func triggerActionClosure() {
        self.setOrTriggerClosure()
    }
    func on(event: UIControlEvents, doThis closure: (UIButton) -> Void) {
        self.setOrTriggerClosure(closure)
        self.addTarget(self, action:
            #selector(UIButton.triggerActionClosure),
                       forControlEvents: event)
    }
}
