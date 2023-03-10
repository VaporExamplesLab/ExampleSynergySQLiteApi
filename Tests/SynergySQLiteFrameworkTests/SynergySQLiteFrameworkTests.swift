import XCTest
@testable import SynergySQLiteFramework

class SynergySQLiteFrameworkTests: XCTestCase {
    
    func testCSqliteModuleAccess() {
        print( SynergySQLite.getSqliteInfo() )
        //XCTAssertEqual(SynergySQLiteFramework().text, "Hello, World!")
    }
    
    func testFindTestProcessInfo() {
        print("\n#################################")
        print("### SynergySQLite.getProcessInfo() ###")
        print("#################################")
        print(SynergySQLite.getProcessInfo())
        
        print("\n#############################################")
        print("### SpmResourcesUtil__C02.getProcessTestInfo() ###")
        print("#############################################")
        print(SpmResourcesUtil__C02.getProcessInfo())
    }
    
    func testReadSqlResource() {
        guard let testResourceUrl = SpmResourcesUtil__C02.getTestResourcesUrl() else { return }
        print("• testResourceUrl==\(testResourceUrl)")
        let sqlUrl = testResourceUrl.appendingPathComponent("TablesTest.sql")
        guard let sql = try? String(contentsOf: sqlUrl) else { return }
        print("• sql==\n\(sql)")
    }
    
    
    let scratchDbFileName = "SQLiteFrameworkTestDB.sqlitedb"
    
    func getTestDbUrl() -> URL? {
        guard let testScratchUrl = SpmResourcesUtil__C02.getTestScratchUrl() 
            else { return nil }
        return testScratchUrl.appendingPathComponent(scratchDbFileName)
    }
    
    /// 
    func doDb01OpenCloseCheck() {
        print("••• doDb01OpenCloseCheck •••")
        guard let scratchUrl = SpmResourcesUtil__C02.getTestScratchUrl() 
            else { return }
        let testDbUrl = scratchUrl.appendingPathComponent("SQLiteFrameworkTestDB01.sqlitedb")
        print("• testDbUrl = \(testDbUrl.path)")
        let db = SynergySQLiteDatabase(url: testDbUrl)
        
        // DATABASE OPEN
        let openedOk: Bool = db.open()
        if !openedOk {
            // :NYI: add error message to log
        }
        
        let sql = "SELECT sqlite_version()"
        let query = SynergySQLiteQuery(sql: sql, db: db)
        if let result = query.getResult() {
            print("• result.columnNames = \(result.columnNames)")
            print("• result.data = \(result.data)")
            print("• result.toStringTsv(true):\n\(result.toStringTsv())")
        }
        else {
            print("")
        }
        
        // CLOSE
        let result = db.close()
        print("• db.close() returned \(result)\n")
    }
    
    func doDb02TableCreate() {
        print("••• doDb02TableCreate •••")
        guard let scratchUrl = SpmResourcesUtil__C02.getTestScratchUrl() 
            else { return }
        let testDbUrl = scratchUrl.appendingPathComponent("SQLiteFrameworkTestDB02.sqlitedb")
        print("• testDbUrl = \(testDbUrl.path)")
        let db = SynergySQLiteDatabase(url: testDbUrl)
        
        // DATABASE OPEN
        let openedOk: Bool = db.open()
        if !openedOk {
            XCTFail("FAIL: could not open database")
        }
        
        let sql01 = """
        CREATE TABLE test_table (
            name  STRING, 
            age   INTEGER,
            score REAL,
            is_present BOOLEAN
        );
        """
        print("• sql01\n\(sql01)")
        let query01 = SynergySQLiteQuery(sql: sql01, db: db)
        print("query01 \(query01.getStatus().toString())")
        
        let sql02 = "PRAGMA table_info(test_table)"
        let query02 = SynergySQLiteQuery(sql: sql02, db: db)
        if let result = query02.getResult() {
            print("• result.columnNames = \(result.columnNames)")
            print("• result.data = \(result.data)")
            print("• result.toStringTsv(true):\n\(result.toStringTsv())")
        }
        
        let sql03 = """
        INSERT INTO test_table (name, age, score, is_present)
        VALUES ( 'Paul', 32, 27.3, 1 );
        """
        _ = SynergySQLiteQuery(sql: sql03, db: db)
        
        let sql04 = """
        INSERT INTO test_table (name, age, score, is_present)
        VALUES ( 'Mary', 78, 65.2, 0 );
        """
        _ = SynergySQLiteQuery(sql: sql04, db: db)
        
        let sql = "SELECT * from test_table"
        let query = SynergySQLiteQuery(sql: sql, db: db)
        if let result = query.getResult() {
            print("• result.columnNames = \(result.columnNames)")
            print("• result.data = \(result.data)")
            print("• result.toStringTsv(true):\n\(result.toStringTsv())")
        }
        else {
            print("FAIL result is nil")
        }
        
        // CLOSE
        let result = db.close()
        print("• db.close() returned \(result)\n")
    }
    
    func doDb03ImportFile() {
        print("••• doDb03ImportFile •••")
        guard let testResourceUrl = SpmResourcesUtil__C02.getTestResourcesUrl() else { return }
        print("• testResourceUrl==\(testResourceUrl)")
        let sqlUrl = testResourceUrl.appendingPathComponent("TablesTest.sql")
        guard let sql = try? String(contentsOf: sqlUrl) else { return }
        print("• sql==\n\(sql)")
        
        guard let scratchUrl = SpmResourcesUtil__C02.getTestScratchUrl() 
            else { return }
        let testDbUrl = scratchUrl.appendingPathComponent("SQLiteFrameworkTestDB03.sqlitedb")
        print("• testDbUrl = \(testDbUrl.path)")
        let db = SynergySQLiteDatabase(url: testDbUrl)
        
        // DATABASE OPEN
        let openedOk: Bool = db.open()
        if !openedOk {
            XCTFail("FAIL: could not open database")
        }
        
        db.importSqlFile(url: sqlUrl, verbose: true)
        
        let sql01 = "PRAGMA table_info(test_table)"
        print("• sql01 = \(sql01)")
        let query01 = SynergySQLiteQuery(sql: sql01, db: db)
        if let result = query01.getResult() {
            print("• result.columnNames = \(result.columnNames)")
            print("• result.data = \(result.data)")
            print("• result.toStringTsv(true):\n\(result.toStringTsv())")
        }

        let sql02 = "SELECT * from test_table"
        print("• sql02 = \(sql02)")
        let query02 = SynergySQLiteQuery(sql: sql02, db: db)
        if let result = query02.getResult() {
            print("• result.columnNames = \(result.columnNames)")
            print("• result.data = \(result.data)")
            print("• result.toStringTsv(true):\n\(result.toStringTsv())")
        }
        
        // DATABASE CLOSE
        let result = db.close()
        print("• db.close() returned \(result)\n")
        
        // **now** seconds since 1970.01.01 00:00:00 UTC
        print("Unix Epoch Seconds == \(Date().timeIntervalSince1970)")
    }
    
    /// Manually check use of TestScratch/ directory
    ///
    /// * macOS Xcode:  …/SynergySQLiteFrameworkTests.xctest/../TestScratch
    /// * macOS CLI:
    /// * Linux:
    func testScratchDatabases() throws {
        try SpmResourcesUtil__C02.resetTestScratch()
        doDb01OpenCloseCheck()
        doDb02TableCreate()
        doDb03ImportFile()
    }
    
    static var allTests = [
        ("testCSqliteModuleAccess", testCSqliteModuleAccess),
        ("testFindTestProcessInfo",testFindTestProcessInfo),
        ("testReadSqlResource", testReadSqlResource),
        ("testScratchDatabases",testScratchDatabases),
        ]
}
