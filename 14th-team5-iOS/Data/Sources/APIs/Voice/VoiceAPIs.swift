//
//  VoiceAPIs.swift
//  Data
//
//  Created by 김도현 on 1/6/25.
//

import Core

enum VoiceAPIs: BBAPI {
    /// 음성 댓글 추가 API
    case createVoiceComment(postId: String, body: CreateVoiceCommentRequestDTO)
    /// 음성 댓글 Presigned URL 생성 API
    case createVoiceCommentPresignedURL(postId: String, body: CreateVoicePresignedURLRequestDTO)
    /// 음성 댓글 삭제 API
    case deleteVoiceComment(postId: String, commentId: String)
    
    var spec: Spec {
        switch self {
        case let .createVoiceComment(postId, body):
            return Spec(method: .post, path: "/posts/\(postId)/voice-comments", bodyParametersEncodable: body)
        case let .createVoiceCommentPresignedURL(postId, body):
            return Spec(method: .post, path: "/posts/\(postId)/voice-comments/audio-file-upload-request", bodyParametersEncodable: body)
        case let .deleteVoiceComment(postId, commentId):
            return Spec(method: .delete, path: "/posts/\(postId)/voice-comments/\(commentId)")
        }
    }
    
    final class Worker: BBRxAPIWorker {
        init() { }
    }
}
