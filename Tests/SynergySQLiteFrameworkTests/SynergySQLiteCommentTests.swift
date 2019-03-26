//
//  SynergySQLiteCommentTests.swift
//
//  Created by marc on 2018.03.02.
//

import XCTest
@testable import SynergySQLiteFramework

class SynergySQLiteCommentTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBlockCommentRemoval() {
        let sqlBlock01 = "a "
        let resultBlock01 = SynergySQLiteDatabase.removingBlockComments(sql: sqlBlock01)
        print("resultBlock01 = \(resultBlock01)")
        XCTAssert(resultBlock01 == "a ", "FAIL: sqlBlock01")
        
        let sqlBlock02 = "abc /* yxz */ def"
        let resultBlock02 = SynergySQLiteDatabase.removingBlockComments(sql: sqlBlock02)
        print("resultBlock02 = \(resultBlock02)")
        XCTAssert(resultBlock02 == "abc /* yxz */ def", "FAIL: sqlBlock02")
        
        let sqlBlock03 = "/*  */"
        let resultBlock03 = SynergySQLiteDatabase.removingBlockComments(sql: sqlBlock03)
        print("resultBlock03 = \(resultBlock03)")
        XCTAssert(resultBlock03 == "", "FAIL: sqlBlock03")

        let sqlBlock04 = "/* \n */"
        let resultBlock04 = SynergySQLiteDatabase.removingBlockComments(sql: sqlBlock04)
        print("resultBlock04 = \(resultBlock04)")
        XCTAssert(resultBlock04 == "", "FAIL: sqlBlock04")

        let sqlBlock05 = " /*  */z"
        let resultBlock05 = SynergySQLiteDatabase.removingBlockComments(sql: sqlBlock05)
        print("resultBlock05 = \(resultBlock05)")
        XCTAssert(resultBlock05 == " z", "FAIL: sqlBlock05")

        let sqlBlock06 = "\t/*  */z"
        let resultBlock06 = SynergySQLiteDatabase.removingBlockComments(sql: sqlBlock06)
        print("resultBlock06 = \(resultBlock06)")
        XCTAssert(resultBlock06 == "\tz", "FAIL: sqlBlock06")

        let sqlBlock07 = "a\n/*  */z"
        let resultBlock07 = SynergySQLiteDatabase.removingBlockComments(sql: sqlBlock07)
        print("resultBlock07 = \(resultBlock07)")
        XCTAssert(resultBlock07 == "a\nz", "FAIL: sqlBlock07")

        let sqlBlock08 = "a\n \t/*  */\t z"
        let resultBlock08 = SynergySQLiteDatabase.removingBlockComments(sql: sqlBlock08)
        print("resultBlock08 = \(resultBlock08)")
        XCTAssert(resultBlock08 == "a\n \t\t z", "FAIL: sqlBlock08")
    }
    
    func testLineCommentRemoval() {
        let sqlLine01 = "ab -- XY"
        let resultLine01 = SynergySQLiteDatabase.removingLineComments(sql: sqlLine01)
        print("resultLine01 = \(resultLine01)")
        XCTAssert(resultLine01 == "ab ", "FAIL: sqlLine01")
        
        let sqlLine02 = "abc - efg"
        let resultLine02 = SynergySQLiteDatabase.removingLineComments(sql: sqlLine02)
        print("resultLine02 = \(resultLine02)")
        XCTAssert(resultLine02 == "abc - efg", "FAIL: sqlLine02")
        
        let sqlLine03 = "a 'Obrien''s Place--Subject' b -- x"
        let resultLine03 = SynergySQLiteDatabase.removingLineComments(sql: sqlLine03)
        print("resultLine03 = \(resultLine03)")
        XCTAssert(resultLine03 == "a 'Obrien''s Place--Subject' b ", "FAIL: sqlLine03")
        
        let sqlLine04 = "'a''' -- xyz"
        let resultLine04 = SynergySQLiteDatabase.removingLineComments(sql: sqlLine04)
        print("resultLine04 = \(resultLine04)")
        XCTAssert(resultLine04 == "'a''' ", "FAIL: sqlLine04")
        
        let sqlLine05 = "'''b' -- xyz"
        let resultLine05 = SynergySQLiteDatabase.removingLineComments(sql: sqlLine05)
        print("resultLine05 = \(resultLine05)")
        XCTAssert(resultLine05 == "'''b' ", "FAIL: sqlLine05")
        
        let sqlLine06 = "c'''''''--''--'''''d -- xyz"
        let resultLine06 = SynergySQLiteDatabase.removingLineComments(sql: sqlLine06)
        print("resultLine06 = \(resultLine06)")
        XCTAssert(resultLine06 == "c'''''''--''--'''''d ", "FAIL: sqlLine06")
        
        let sqlLine07 = "'' -- xyz"
        let resultLine07 = SynergySQLiteDatabase.removingLineComments(sql: sqlLine07)
        print("resultLine07 = \(resultLine07)")
        XCTAssert(resultLine07 == "'' ", "FAIL: sqlLine07")
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    static var allTests = [
        ("testBlockCommentRemoval", testBlockCommentRemoval),
        ("testLineCommentRemoval",testLineCommentRemoval),
        ]
    
}
