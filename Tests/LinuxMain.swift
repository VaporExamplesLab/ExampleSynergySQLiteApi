import XCTest

import SynergySQLiteFrameworkTests

var tests = [XCTestCaseEntry]()
tests += SynergySQLiteExtensionTests.allTests()
tests += SynergySQLiteFrameworkTests.allTests()
tests += SynergySQLiteCommentTests.allTests()
XCTMain(tests)
