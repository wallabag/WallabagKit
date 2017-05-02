//
//  TagTests.swift
//  WallabagKit
//
//  Created by maxime marinel on 26/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import WallabagKit

class TagTests: XCTestCase {

    func testTagFromDict() {
        let tag = Tag(fromDictionary: [
            "id": 42,
            "label": "My tag",
            "slug": "my-tag"
            ])

        XCTAssertEqual(42, tag.id)
        XCTAssertEqual("My tag", tag.label)
        XCTAssertEqual("my-tag", tag.slug)
    }

    func testTagEqual() {
        let tag = Tag(fromDictionary: ["id": 42, "label": "My tag", "slug": "my-tag"])
        let tag1 = Tag(fromDictionary: ["id": 42, "label": "My tag", "slug": "my-tag"])

        XCTAssertTrue(tag == tag1)
    }

    func testTagNotEqual() {
        let tag = Tag(fromDictionary: ["id": 42, "label": "My tag", "slug": "my-tag"])
        let tag1 = Tag(fromDictionary: ["id": 43, "label": "My tag", "slug": "my-tag"])

        XCTAssertFalse(tag == tag1)
    }
}
