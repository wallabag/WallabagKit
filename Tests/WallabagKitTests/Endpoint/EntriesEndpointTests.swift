//
//  WallabagKitTests.swift
//  wallabag
//
//  Created by Marinel maxime on 07/06/2019.
//  Copyright © 2019 wallabag. All rights reserved.
//

import Foundation
import WallabagKit
import Alamofire
import XCTest

class EntriesEndpointTests: XCTestCase {
    func testGetAll() {
    	XCTAssertEqual("/entries", try! EntriesEndpoint.getAll(page: 1).getUrl().asURL().path)
    	XCTAssertEqual(.get, EntriesEndpoint.getAll(page: 1).getMethod())
    	XCTAssertEqual(["page": 15], EntriesEndpoint.getAll(page: 15).getParameters() as? [String: Int])
    }

    static var allTests = [
        ("testGetAll", testGetAll),
    ]
}
