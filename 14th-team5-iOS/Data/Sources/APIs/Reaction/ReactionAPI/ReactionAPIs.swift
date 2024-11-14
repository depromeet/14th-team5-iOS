//
//  EmojiAPIs.swift
//  Data
//
//  Created by 마경미 on 01.01.24.
//

import Core
import Foundation

enum ReactionAPIs: API {
    case addReactions(String)
    case removeReactions(String)
    case fetchReactions(FetchReactionRequestDTO)
    
    var spec: APISpec {
        switch self {
        case let .addReactions(postId):
            let urlString = "\(BibbiAPI.hostApi)/posts/\(postId)/reactions"
            return APISpec(method: .post, url: urlString)
        case let .removeReactions(postId):
            let urlString = "\(BibbiAPI.hostApi)/posts/\(postId)/reactions"
            return APISpec(method: .delete, url: urlString)
        case let .fetchReactions(postId):
            let urlString = "\(BibbiAPI.hostApi)/posts/\(postId.postId)/reactions"
            return APISpec(method: .get, url: urlString)
        }
    }
}

enum ReactionAPI: BBAPI {
    /// 게시물 일반 반응 추가
    case addReactions(_ postId: String)
    /// 게시물 일반 반응 삭제
    case removeReactions(_ postId: String)
    /// 게시물 일반 반응 전체 조회
    case fetchReactions(_ postId: String)
    
    var spec: Spec {
        switch self {
        case .addReactions(let postId):
            return .init(method: .post, path: "/posts/\(postId)/reactions")
        case .removeReactions(let postId):
            return .init(method: .delete, path: "/posts/\(postId)/reactions")
        case .fetchReactions(let postId):
            return .init(method: .get, path: "/posts/\(postId)/reactions")
        }
    }
}
