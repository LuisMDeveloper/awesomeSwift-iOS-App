//
//  Utilities.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 17/04/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit
import SafariServices

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
