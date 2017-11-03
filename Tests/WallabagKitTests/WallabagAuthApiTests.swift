//
//  WallabagAuthApiTests.swift
//  WallabagKit
//
//  Created by maxime marinel on 04/12/2017.
//  Copyright © 2017 WallabagKit. All rights reserved.
//

import Foundation
import XCTest
import Alamofire
@testable import WallabagKit

class WallabagAutApiTests: XCTestCase {
    func testAuth() {
        let expectation = XCTestExpectation(description: "Download apple.com home page")

        let auth = WallabagAuthApi(host: "http://wallabag.maxime.marinel.me", username: "wallabag", password: "wallabag", clientId: "1_5ng39qhew3s4kc84ww00ck88wcowkgckc440skgss0wk8k4ooo", clientSecret: "2kc4oo9ahgys0kko04sgc40oscks0g8kwcgsw0c0os0ss844g8", sessionManager: SessionManager())

        let api = WallabagApi(auth: auth)

        api.entry() { 
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)
    }

    static var allTests = [
        ("testAuth", testAuth),
        ]
}
