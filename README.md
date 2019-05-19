# SynergySQLiteFramework

<a id="toc"></a>
[API Summary](#ApiSummary) •
[Example](#Example) •
[Notes](#Notes) •
[Subproject Usage](#SubprojectUsage) •
[Original Setup](#OriginalSetup) •
[Resources](#Resources)

## API Summary <a id="ApiSummary"></a>[▴](#toc)

#### SynergySQLite (Utilities)

``` swift
static func escapeLikeString(_ s: String, escapeChar: String) -> String 
static func getProcessInfo() -> [String:String]
static func getSqliteInfo() -> [String:String]
```

#### SynergySQLiteDatabase -- database connection

``` swift
SynergySQLiteDatabase(pathname: String, options: OptionDictionary = [:])

func open()   -> Bool   // true: successful open
func close()  -> Bool   // true: successful open

func isOpen()    -> Bool
func getStatus() -> SynergySQLiteStatus
func hasError()  -> Bool

func importSql(filepath: String)
```

#### SynergySQLiteQuery

Use `SynergySQLiteQuery` manipulating and executing SQL statements.

_Note: only the first statement will be executed.  Separate multiple statements into multiple SynergySQLiteQuery. ... or :NYI: set up a bind parameter._

``` swift
SynergySQLiteQuery(db: SynergySQLiteDatabase) 
func statementPrepare(_ sql: String) -> Int // returns Int status
func statementReset()
func statementBind(paramIndex: Int32, paramValue: String) -> Int32
func statementExecute() // creates SynergySQLiteResult()

func getResult() -> SynergySQLiteResult?

func getStatus() -> SynergySQLiteStatus
func hasError()  -> Bool

// executes non-empty query
SynergySQLiteQuery(sql: String, db: SynergySQLiteDatabase)

// :NYI:   
// .bindValue(placeholder, value, type) 
// .bindValue(position, value, type)
// .boundValue(placeholder) 
// .boundValue(position)

```

#### SynergySQLiteResult

Created by `SynergySQLiteQuery` execution. `SynergySQLiteResult` is used for reading and formatting results. 

``` swift
public var columnNames: [String]
// :NYI: columnType: [SynergySQLiteResultTypes]
// :???: ponder column type in Query for mapping int to boolean
public var data: [[Any?]]

func toStringTsv(withColumnNames: Bool = true) -> String
// :NYI: toStringJson(withColumnNames: Bool = true)

func getRowData(rowIdx: Int) -> [Any?]
```

#### SynergySQLiteStatus

`SynergySQLiteStatus` provides status and error information.

## Example <a id="Example"></a>[▴](#toc)

``` swift
("select * from employees");
columnCount() // column fields 
columnIndex("name"); // index of column field "name"
columnType("name"), columnType(index)
rowCount() // rows
```

## Notes <a id="Notes"></a>[▴](#toc)

Boolean values are inserted and returned as `0` or `1`.

In Xcode the C header files need to be manually added to the project.

![BuildSettingsCHeaders](README_files/BuildSettingsCHeaders.png)

The script ['swift-copy-testresources.swift'](swift-copy-testresources.swift) is used to copy the test database to a known location to support the tests.

``` swift
#!/usr/bin/swift

// FILE: swift-copy-testresources.sh
// verify swift path with "which -a swift"
// macOS: /usr/bin/swift 
// Ubuntu: /opt/swift/current/usr/bin/swift 

import Foundation

func copyTestResources() {
    let argv = ProcessInfo.processInfo.arguments
//     for i in 0..<argv.count {
//         print("argv[\(i)] = \(argv[i])")
//     }
    
    let pwd = argv[argv.count-1]
    print("Executing swift-copy-testresources")
    print("  PWD=\(pwd)")
    
    let fm = FileManager.default
    
    let pwdUrl = URL(fileURLWithPath: pwd, isDirectory: true)
    let srcUrl = pwdUrl
        .appendingPathComponent("TestResources", isDirectory: true)
    let dstUrl = pwdUrl
        .appendingPathComponent(".build", isDirectory: true)
        .appendingPathComponent("TestResources", isDirectory: true)
    
    do {
        let contents = try fm.contentsOfDirectory(at: srcUrl, includingPropertiesForKeys: [])
        do { try fm.removeItem(at: dstUrl) } catch { }
        try fm.createDirectory(at: dstUrl, withIntermediateDirectories: true)
        for fromUrl in contents {
            try fm.copyItem(
                at: fromUrl, 
                to: dstUrl.appendingPathComponent(fromUrl.lastPathComponent)
            )
        }
    } catch {
        print("  SKIP TestResources not copied. ")
        return
    }
            
    print("  SUCCESS TestResources copy completed.\n  FROM \(srcUrl)\n  TO \(dstUrl)")
}

copyTestResources()
```

## Subproject Usage <a id="SubprojectUsage"></a>[▴](#toc)

1. Clone Repository

    ``` bash
    cd WORKING_DIRECTORY
    git clone git@github.com:VaporExamplesLab/SynergySQLiteFramework.git
    ```

2. Create Xcode project

    ``` bash
    cd SynergySQLiteFramework

    # for macOS
    swift package generate-xcodeproj --xcconfig-overrides Package.xcconfig
    ```

3. Verify `DEFINES_MODULE = YES` in Project Editor > Target > Build Settings.

4. Drag and drop SynergySQLiteFramework.xcodeproj as subproject to the parent Xcode project.

5. In the parent Xcode project, Project Editor > Target > Build Phases:
    * `+` add to Target Dependencies
    * `+` add to Link Binary With Libraries

## Original Setup <a id="OriginalSetup"></a>[▴](#toc)

_Steps taken to initial setup this project._

``` bash
mkdir SynergySQLiteFramework
cd SynergySQLiteFramework
swift package init
git init
git add README.md
git commit -m "first commit"
git remote add origin git@github.com-*:VaporExamplesLab/SynergySQLiteFramework.git
git push -u origin master

# swift build -Xswiftc "-target" -Xswiftc "x86_64-apple-macosx10.13"
swiftbuild # alias

# swift test -Xswiftc "-target" -Xswiftc "x86_64-apple-macosx10.13"
swifttest # alias

# swift package generate-xcodeproj --xcconfig-overrides Configs/Package.xcconfig
swiftxcode # alias
open SynergySQLiteFramework.xcodeproj
```

## Resources <a id="Resources"></a>[▴](#toc)

[SQLite: SQL As Understood By SQLite ⇗](https://www.sqlite.org/lang.html)  
[SQLite: Core Functions ⇗](https://www.sqlite.org/lang_corefunc.html)  
[SQLite: PRAGMA Statements ⇗](https://www.sqlite.org/pragma.html) … SQL extension specific to SQLite. Used to modify the operation of the SQLite library or to query the SQLite library for internal (non-table) data.  
