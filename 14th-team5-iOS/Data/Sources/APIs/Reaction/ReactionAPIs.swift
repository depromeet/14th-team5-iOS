//
//  EmojiAPIs.swift
//  Data
//
//  Created by 마경미 on 01.01.24.
//

import Core

enum ReactionAPIs: BBAPI {
    /// 게시물 일반 반응 추가
    case addReactions(_ postId: String, _ body: AddReactionRequestDTO)
    /// 게시물 일반 반응 삭제
    case removeReactions(_ postId: String, _ body: RemoveReactionRequestDTO)
    /// 게시물 일반 반응 전체 조회
    case fetchReactions(_ postId: String)
    
    var spec: Spec {
        switch self {
        case .addReactions(let postId, let body):
            return .init(
                method: .post,
                path: "/posts/\(postId)/reactions",
                bodyParametersEncodable: body
            )
        case .removeReactions(let postId, let body):
            return .init(
                method: .delete,
                path: "/posts/\(postId)/reactions",
                bodyParametersEncodable: body
            )
        case .fetchReactions(let postId):
            return .init(
                method: .get,
                path: "/posts/\(postId)/reactions"
            )
        }
    }
    
    final class Worker: BBRxAPIWorker {
        init() { }
    }
}
