//
//  SynergySQLiteExtension.swift
//  SynergySQLiteFramework
//
//  Created by marc on 2018.03.09.
//

import Foundation


public extension Bool  {
    
    /// ANSI C: if (NON_ZERO_EXPRESSION) then { EXECUTE_CODE_BLOCK }
    /// SQLite: Boolean values are stored as integers 0 (false) and 1 (true).
    public init(int: Int) {
        if int == 0 {
            self.init(false)
        }
        else {
            self.init(true)
        }
    }
    
    public func rawInt() -> Int {
        return (self == false) ? 0 : 1
    }
    
}

public extension String {

    /// Convert SQLite column string to Swift String. "NULL" return nil
    public static func fromColumn(string o: Any) -> String? {
        if let s = o as? String {
            if s.caseInsensitiveCompare("NULL") != ComparisonResult.orderedSame {
                return s
            }            
        }
        return nil
    }
    
}
