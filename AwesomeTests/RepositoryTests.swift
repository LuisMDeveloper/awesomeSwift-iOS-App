//
//  RepositoryTests.swift
//  awesomeswift
//
//  Created by Matteo Crippa on 27/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import XCTest

class RepositoryTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // swiftlint:disable force_try
        let realm = try! Realm(configuration: Realm.Configuration(path: nil, inMemoryIdentifier: "test", encryptionKey: nil, readOnly: false, schemaVersion: 0, migrationBlock: nil, objectTypes: nil))
        // swiftlint:disable force_try
        try! realm.write { () -> Void in
            realm.deleteAll()
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testInit_ShouldTakeName() {
    }
}
