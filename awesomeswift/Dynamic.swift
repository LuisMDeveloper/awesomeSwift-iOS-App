//
//  Dynamic.swift
//  awesomeswift
//
//  Created by Matteo Crippa on 11/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit

class Dynamic<T> {
    typealias Listener = T -> Void
    var listener: Listener?
    
    func bind(listener: Listener?) {
        self.listener = listener
    }
    
    func bindAndFire(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ v: T) {
        value = v
    }
}
