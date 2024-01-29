//
//  FetchEmojiData.swift
//  Domain
//
//  Created by 마경미 on 03.01.24.
//

import Foundation
import Core

public struct FetchEmojiData: Equatable {
    public var isSelfSelected: Bool
    public var count: Int
    public var memberIds: [String]
    
    public init(isSelfSelected: Bool, count: Int, memberIds: [String]) {
        self.isSelfSelected = isSelfSelected
        self.count = count
        self.memberIds = memberIds
    }
}

public struct FetchEmojiDataList {
    public let emojis_memberIds: [FetchEmojiData]
    
    public init(emojis_memberIds: [FetchEmojiData]) {
        self.emojis_memberIds = emojis_memberIds
    }
}
