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

class WallabagSessionManagerTests: XCTestCase {

    func testCreateSession() {
        let auth = WallabagSessionManager(host: "http://myhost", username: "myUsername", password: "myPassword", clientId: "myCLientId", clientSecret: "myClientSecret")

        let session = auth.createSession()
        guard let adapter = session.adapter as? BearerTokenAdapter,
            let _ = session.retrier as? BearerTokenAdapter else {
            XCTAssertTrue(false)
            return
        }

        XCTAssertEqual("http://myhost", auth.host)
        XCTAssertEqual("myUsername", auth.username)
        XCTAssertEqual("myPassword", auth.password)
        XCTAssertEqual("myCLientId", auth.clientId)
        XCTAssertEqual("myClientSecret", auth.clientSecret)
        
        XCTAssertEqual("http://myhost", adapter.baseURLString)
        XCTAssertEqual("myUsername", adapter.username)
        XCTAssertEqual("myPassword", adapter.password)
        XCTAssertEqual("myCLientId", adapter.clientID)
        XCTAssertEqual("myClientSecret", adapter.clientSecret)
    }

    static var allTests = [
        ("testCreateSession", testCreateSession)
    ]
}
