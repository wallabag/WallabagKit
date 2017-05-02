
import XCTest
@testable import WallabagKit

class ExtensionTests: XCTestCase {
    func testMerge() {
        let dic = ["Key": "Value"]
        let merged = dic.merge(dict: ["OtherKey": "OtherValue"])

        XCTAssertEqual(["Key": "Value", "OtherKey": "OtherValue"], merged)
    }

    func testMergeWithSameKeyEraseValue() {
        let dic = ["Key": "Value"]
        let merged = dic.merge(dict: ["Key": "OtherValue"])

        XCTAssertEqual(["Key": "OtherValue"], merged)
    }

    func testDateWithWrongFormatReturnNil() {
        XCTAssertNil("".date)
    }

    func testDateWithGoodFormatReturnDate() {
        let date = "2016-11-10T17:34:20+0100".date

        XCTAssertNotNil(date)

        let components = Calendar.current.dateComponents([.hour, .minute, .second, .day, .month, .year], from: date!)

        XCTAssertEqual(2016, components.year)
        XCTAssertEqual(11, components.month)
        XCTAssertEqual(10, components.day)
    }

    func testUcFirst() {
        let string = "test"

        XCTAssertEqual("Test", string.ucFirst)
    }

    func testLcFirst() {
        let string = "Test"

        XCTAssertEqual("test", string.lcFirst)
    }
}
