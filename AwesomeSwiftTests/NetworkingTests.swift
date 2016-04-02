//
//  NetworkingTests.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 02/04/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import Nimble
import Quick
@testable import AwesomeSwift

class NetworkingTests: QuickSpec {
    override func spec() {

        let sut = Networking()

        describe("networking") {
            context("categories") {
                it("remote provides data") {
                    sut.getCats {
                        cats, error in
                        expect(error).to(beNil())
                        expect(cats!.count).to(beGreaterThanOrEqualTo(0))
                    }
                }
            }
            context("repositories") {
                it("remote provides data") {
                    sut.getRepositories {
                        repos, error in
                        expect(error).to(beNil())
                        expect(repos!.count).to(beGreaterThanOrEqualTo(0))
                    }
                }
            }
        }
    }
}
