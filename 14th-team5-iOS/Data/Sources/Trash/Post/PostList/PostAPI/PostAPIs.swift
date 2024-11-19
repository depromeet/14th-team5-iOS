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
    case fetchPostList(page: Int, size: Int, date: String, memberId: String?, sort: String, type: String)
    /// 게시물 생성 API
    case createPost(type: String)
    /// 가족 미션 키 획득 여부 응답 조회  API
    case fetchMissionKeyAvailable(memberId: String)
    /// 사용자 미션 게시글 업로드 업로드 여부 응답 조회 API
    case fetchMissionPostAvailable(memberId: String)
    /// 미션 키  획득 까지 남은 생존신고 업로드 수 API
    case fetchRemainingSurvivalUploadCount(memberId: String)
    /// 생존 신고 게시글 업로드 업로드 여부 응답 조회 API
    case fetchSurvivalPostAvailable(memberId: String)
    /// 게시물 단일 조회 API
    case fetchPostDetail(postId: String)
    /// 게시물 사진 Presigned URL 요청 API
    case createFeedPresignedURL
    
    var spec: Spec {
        switch self {
        case let .fetchPostList(page, size, date, memberId, sort, type):
            return Spec(
                method: .get,
                path: "/v1/posts",
                queryParameters: [
                    .page: "\(page)",
                    .size: "\(size)",
                    .date: "\(date)",
                    .memberId: "\(memberId)",
                    .sort: "\(sort)",
                    .type: "\(type)",
                ]
            )
        case let .createPost(type):
            return Spec(
                method: .post,
                path: "/v1/posts",
                queryParameters: [
                    .type: "\(type)"
                ]
            )
        case let .fetchMissionKeyAvailable(memberId):
            return Spec(method: .get, path: "/v1/posts/\(memberId)/mission-available")
        case let .fetchMissionPostAvailable(memberId):
            return Spec(method: .get, path: "/v1/posts/\(memberId)/mission-uploaded")
        case let .fetchRemainingSurvivalUploadCount(memberId):
            return Spec(method: .get, path: "/v1/posts/\(memberId)/remaining-survival-upload-count")
        case let .fetchSurvivalPostAvailable(memberId):
            return Spec(method: .get, path: "/v1/posts/\(memberId)/survival-uploaded")
        case let .fetchPostDetail(postId):
            return Spec(method: .get, path: "/v1/posts/\(postId)")
        case .createFeedPresignedURL:
            return Spec(method: .post, path: "/v1/posts/image-upload-request")
        }
    }
    
    public final class Worker: BBRxAPIWorker {
        public init() { }
    }
}
