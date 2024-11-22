//
//  CreateFeedRequestDTO.swift
//  Data
//
//  Created by 김도현 on 11/17/24.
//

import Foundation

public struct CreateFeedRequestDTO: Encodable {
    public let imageUrl: String
    public let content: String
    public let uploadTime: String
}

