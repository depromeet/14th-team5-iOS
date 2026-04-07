//
//  CreatePostRequestDTO.swift
//  Data
//
//  Created by 김도현 on 11/19/24.
//

import Foundation


public struct CreatePostRequestDTO: Encodable {
    public let imageUrl: String
    public let content: String
    public let uploadTime: String
    public let latitude: Double?
    public let longitude: Double?
    public let address: String?
}

