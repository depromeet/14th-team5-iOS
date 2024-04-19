//
//  ProfilePostDTO.swift
//  Domain
//
//  Created by Kim dohyun on 12/26/23.
//

import Foundation

import Core
import Domain


public struct ProfilePostDTO: Decodable {
    public var currentPage: Int
    public var totalPage: Int
    public var itemPerPage: Int
    public var hasNext: Bool
    public var results: [ProfilePostResponseDTO]
    
  
  public enum CodingKeys: String, CodingKey {
    case currentPage, totalPage, itemPerPage
    case hasNext
    case results
  }
  
}

extension ProfilePostDTO {
    
  public struct ProfilePostResponseDTO: Decodable {
    public var postId: String
    public var authorId: String
    public var commentCount: Int
    public var emojiCount: Int
    public var imageUrl: String
    public var content: String
    public var createdAt: String
    public var missionId: String?
    public var missionType: String?
    
    
    public enum CodingKeys: String, CodingKey {
      case postId, authorId, content, imageUrl, createdAt, missionId
      case commentCount, emojiCount
      case missionType = "type"
    }
  }
  
}


extension ProfilePostDTO {
    public func toDomain() -> ProfilePostResponse {
        return .init(
            currentPage: currentPage,
            totalPage: totalPage,
            itemPerPage: itemPerPage,
            hasNext: hasNext,
            results: results.map { $0.toDomain() }
        )
    }
}

extension ProfilePostDTO.ProfilePostResponseDTO {
    public func toDomain() -> ProfilePostResultResponse {
        return .init(
            postId: postId,
            authorId: authorId,
            commentCount: "\(commentCount)",
            emojiCount: "\(emojiCount)",
            imageUrl: URL(string: imageUrl) ?? URL(fileURLWithPath: ""),
            content: content,
            createdAt: createdAt,
            missionId: missionId ?? "",
            missionType: missionType ?? ""
        )
    }
}
