//
//  StudioCountEntity.swift
//  Domain
//
//  Created by 마경미 on 27.09.25.
//

public struct StudioCountEntity {
    public let postCount: Int
    public let availableCount : Int
    
    public init(
        postCount: Int,
        availableCount: Int
    ) {
        self.postCount = postCount
        self.availableCount = availableCount
    }
}
