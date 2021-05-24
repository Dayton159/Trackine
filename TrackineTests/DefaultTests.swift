//
//  DefaultTests.swift
//  TrackineTests
//
//  Created by Dayton on 23/04/21.
//

import XCTest
@testable import Trackine

class DefaultTests: XCTestCase {
    var defaults: Defaults<String>?

    override func setUp() {
      super.setUp()
      
        let testObject = Defaults(key: "tes123", defaultValue: "tes234")
        defaults = testObject
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "tes123")
      
      super.tearDown()
    }

    func testGetDefaultValue() {
          let value = defaults?.wrappedValue
          XCTAssertEqual("tes234", value)
    }

    func testSetDefaults() {
      do {
        defaults?.wrappedValue = "tes12345"
        XCTAssertEqual("tes12345", defaults?.wrappedValue)
      }
    }

}
