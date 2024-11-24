//
//  PostAPIs.swift
//  Data
//
//  Created by 마경미 on 25.12.23.
//

import Core
import Foundation

/// 해당 Posts API는 Swagger에 있는 **게시물 API** 기준으로 사용되는 API 입니다.
enum PostsAPIs: BBAPI {
    /// 게시물 조회 API
    case fetchPostList(query: PostListQueryDTO)
    /// 게시물 생성 API
    case createPost(type: String, body: CreatePostRequestDTO)
    /// 게시물 단일 조회 API
    case fetchPostDetail(postId: String)
    /// 게시물 사진 Presigned URL 요청 API
    case createPostPresignedURL(body: CreatePostPresignedURLReqeustDTO)
    
    
    var spec: Spec {
        switch self {
        case let .fetchPostList(query):
            return Spec(
                method: .get,
                path: "/posts",
                queryParametersEncodable: query
            )
        case let .createPost(type, body):
            return Spec(
                method: .post,
                path: "/posts",
                queryParameters: [
                    .type: "\(type)"
                ],
                bodyParametersEncodable: body
            )
        case let .fetchPostDetail(postId):
            return Spec(method: .get, path: "/posts/\(postId)")
        case let .createPostPresignedURL(body):
            return Spec(method: .post, path: "/posts/image-upload-request", bodyParametersEncodable: body)
        }
    }
    
    public final class Worker: BBRxAPIWorker {
        public init() { }
    }
}
