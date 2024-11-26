//
//  RealEmojiAPIS.swift
//  Data
//
//  Created by 마경미 on 22.01.24.
//

import Core
import Foundation

enum PostRealEmojiAPIs: BBAPI {
    /// 게시물에 리얼 이모지 등록
    case addRealEmojiReaction(_ postId: String, _ body: AddRealEmojiRequestDTO)
    /// 게시물에서 리얼 이모지 삭제
    case removeRealEmojiReactions(_ postId: String, _ realEmojiId: String)
    /// 게시물의 리얼 이모지 전체 조회
    case fetchRealEomjiReactions(_ postId: String)
    
    var spec: Spec {
        switch self {
        case .addRealEmojiReaction(let postId, let body):
            return .init(
                method: .post,
                path: "/posts/\(postId)/real-emoji",
                bodyParametersEncodable: body
            )
        case .removeRealEmojiReactions(let postId, let realEmojiId):
            return .init(
                method: .delete,
                path: "/posts/\(postId)/real-emoji/\(realEmojiId)"
            )
        case .fetchRealEomjiReactions(let postId):
            return .init(method: .get, path: "/posts/\(postId)/real-emoji")
        }
    }
    
    final class Worker: BBRxAPIWorker {
        init() { }
    }
}
