import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SynergySQLiteExtensionTests.allTests),
        testCase(SynergySQLiteFrameworkTests.allTests),
        testCase(SynergySQLiteCommentTests.allTests),
    ]
}
#endif