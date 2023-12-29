//
//  ProfilePostParameter.swift
//  Domain
//
//  Created by Kim dohyun on 12/26/23.
//

import Foundation



public struct ProfilePostParameter: Encodable {
    public var page: Int
    public var size: Int
    public var date: String
    public var memberId: String
    public var sort: String
    
    public init(page: Int, size: Int, date: String, memberId: String, sort: String) {
        self.page = page
        self.size = size
        self.date = date
        self.memberId = memberId
        self.sort = sort
    }
}

public struct ProfilePostDefaultValue: Encodable {
    public var date: String
    public var memberId: String
    public var sort: String
    
    public init(date: String, memberId: String, sort: String) {
        self.date = date
        self.memberId = memberId
        self.sort = sort
    }
    
}

public struct ProfilePostQuery: Encodable {
    public var page: Int
    public var size: Int
    
    public init(page: Int, size: Int) {
        self.page = page
        self.size = size
    }
}

