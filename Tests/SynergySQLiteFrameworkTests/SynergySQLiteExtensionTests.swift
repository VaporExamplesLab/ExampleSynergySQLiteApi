//
//  SynergySQLiteExtensionTests.swift
//  SynergySQLiteFrameworkTests
//
//  Created by marc on 2018.03.09.
//

import XCTest

@testable import SynergySQLiteFramework

class SynergySQLiteExtensionTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBooleanExtension() {
        let aFalse: Bool = Bool(int: 0)
        XCTAssert(!aFalse)

        let aTrue: Bool = Bool(int: 1)        
        XCTAssert(aTrue)
        
        XCTAssert(aFalse.rawInt() == 0)
        XCTAssert(aTrue.rawInt() == 1)
    }
    
    func testStringExtension() {
        XCTAssert(String.fromColumn(string: 0) == nil)
        XCTAssert(String.fromColumn(string: "NULL") == nil)
        XCTAssert(String.fromColumn(string: "null") == nil)
        XCTAssert(String.fromColumn(string: "Something") == "Something")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    static var allTests = [
        ("testBooleanExtension", testBooleanExtension),
        ("testStringExtension", testStringExtension),
        ]

}
