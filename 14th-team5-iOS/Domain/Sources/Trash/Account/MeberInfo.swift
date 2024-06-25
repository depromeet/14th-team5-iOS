//
//  MeberInfo.swift
//  Domain
//
//  Created by geonhui Yu on 1/3/24.
//

import Foundation

public struct MemberInfo: Codable, Equatable {
    public var memberId: String
    public var name: String
    public var imageUrl: String?
    public var familyId: String?
    public var dayOfBirth: String
}
