//
//  SynergySQLiteFramework/SynergySQLiteStatus.swift
//  aknowtz
//
//  Created by marc on 2016.03.28.
//  Copyright © 2016 Tinker. All rights reserved.
//

import Foundation

public enum SynergySQLiteStatusType {
    /// No error occurred
    case noError
    /// Connection (open) error
    case connectionError
    /// SQL statement syntax error
    case statementError    
    /// Transaction failed error
    case transactionError  
    /// Unknown error
    case unknownError      
}

public struct SynergySQLiteStatus {

    public let context: String
    public let dbCode: Int32
    public let dbMessage: String
    public let type: SynergySQLiteStatusType
    // let isValid: Bool

    public init(type: SynergySQLiteStatusType, context: String) {
        self.context = context
        self.dbCode = 0
        self.dbMessage = ""
        self.type = type
    }

    public init(type: SynergySQLiteStatusType, context: String, dbMessage: String) {
        self.context = context
        self.dbCode = 0
        self.dbMessage = dbMessage
        self.type = type
    }

    public init(type: SynergySQLiteStatusType, context: String, dbCode: Int32, dbMessage: String) {
        self.context = context
        self.dbCode = dbCode
        self.dbMessage = dbMessage
        self.type = type
    }

    public func toString() -> String {        
        return "STATUS:\(type):\(context):\(dbCode):\(dbMessage)"
    }
    
    // :NYI: operators == != =

}
