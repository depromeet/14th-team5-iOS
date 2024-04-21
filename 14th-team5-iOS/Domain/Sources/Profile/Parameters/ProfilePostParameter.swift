//
//  ProfilePostParameter.swift
//  Domain
//
//  Created by Kim dohyun on 12/26/23.
//

import Foundation

//TODO: BibbiFeedType (임시로 넣어둠 홈이랑 공유 해서 사용하기에 논의후 위치 변경)
public enum BibbiFeedType: String {
  case survival = "SURVIVAL"
  case mission = "MISSION"
}

public struct ProfilePostParameter: Encodable {
    public var page: Int
    public var size: Int
    public var date: String
    public var memberId: String
    public var type: String
    public var sort: String
    
    public init(page: Int, size: Int, date: String, type: String, memberId: String, sort: String) {
        self.page = page
        self.size = size
        self.date = date
        self.type = type
        self.memberId = memberId
        self.sort = sort
    }
}

public struct ProfilePostDefaultValue: Encodable {
    public var date: String
    public var memberId: String
    public var type: String
    public var sort: String
    
    public init(date: String, memberId: String, type: String, sort: String) {
        self.date = date
        self.memberId = memberId
        self.type = type
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

