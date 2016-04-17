//
//  Utilities.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 17/04/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit

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
