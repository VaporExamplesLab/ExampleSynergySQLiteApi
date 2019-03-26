////////////////////////////////////////////////////////////////////////////////
//
//  SynergySQLiteFramework/SynergySQLiteResult.swift
//
//  Created by marc on 2016.04.02.
//  Copyright © 2016 Tinker. All rights reserved.
//


import Foundation

/// SynergySQLiteResult class provides an abstract interface for accessing data
/// 
/// Design Option: each row has 2D values array with 1D column name array.
/// 
public struct SynergySQLiteResult {
    /// :WIP:ACCESS_LEVEL:
    public var columnNames: [String]
    // var columnType or blobType: [String: some_type ] // column name string: type
    /// :WIP:ACCESS_LEVEL:
    public var data: [[Any?]]
    
    // 
    public init() {
        self.columnNames = [] 
        self.data = [[Any?]]()
    }
    
    //
    public func toStringTsv(withColumnNames: Bool = true) -> String {
        var s = ""
        if (withColumnNames) {
            var cIdx = 0
            while cIdx < columnNames.count {
                s += columnNames[cIdx]
                s += cIdx < columnNames.count - 1 ? "\t" : "\n"
                cIdx += 1
            }
        }
        
        for row in data {
            var columnIdx = 0
            while columnIdx < row.count {
                if let value = row[columnIdx] {
                   s += "\(value)"
                }
                else {
                    s += "" // "NULL"
                }
                s += columnIdx < row.count - 1 ? "\t" : "\n"
                columnIdx += 1
            }
        }
        
        return s
    }
    
    /// Element types can be any of `Int`, `Double`, `String` or `nil`
    ///
    /// - Returns: single row record of data. 
    public func getRowData(rowIdx: Int) -> [Any?] {
        return data[rowIdx]
    }
}
