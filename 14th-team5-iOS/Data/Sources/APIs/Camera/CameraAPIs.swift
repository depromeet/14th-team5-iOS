//
//  CameraAPIs.swift
//  Data
//
//  Created by Kim dohyun on 12/21/23.
//

import Core
import Domain
import Foundation


enum CameraAPIs: BBAPI {
    /// 회원 프로필 Presigend URL 요청 API
    case createProfilePresignedURL(body: CreatePresignedURLReqeustDTO)
    /// 회원 프로필 이미지 수정 API
    case updateProfileImage(memberId: String, body: UpdateProfileImageRequestDTO)
    /// 게시물 사진 Presigned URL 요청 API
    case createFeedPresignedURL(body: CreatePresignedURLReqeustDTO)
    /// S3 Bucket 업로드 API
    case uploadTos3Bucket(presignedURL: String)
    /// 게시물 생성 API
    case createFeed(type: String, body: CreateFeedRequestDTO)
    /// 리얼 이모지 Presigned URL 요청 API
    case createRealEmojiPresignedURL(memberID: String, body: CreatePresignedURLReqeustDTO)
    /// 리얼 이미지 추가 API
    case createRealEmojiImage(memberId: String, body: CreateEmojiImageReqeustDTO)
    /// 리얼 이미지 조회 API
    case fetchRealEmojiImage(memberId: String)
    /// 리얼 이모지 수정 API
    case updateRealEmojiImage(memberId: String, realEmojiId: String, body: UpdateRealEmojiImageRequestDTO)
    /// 금일의 일일 미션 조회 API
    case fetchTodayMission
    
    var spec: Spec {
        switch self {
        case let .createProfilePresignedURL(body):
            return Spec(method: .post, path: "/members/image-upload-request", bodyParametersEncodable: body)
        case let .updateProfileImage(memberId, body):
            return Spec(method: .put, path: "/members/profile-image-url/\(memberId)", bodyParametersEncodable: body)
        case let .createFeedPresignedURL(body):
            return Spec(method: .post, path: "/posts/image-upload-request", bodyParametersEncodable: body)
        case let .uploadTos3Bucket(presignedURL):
            return Spec(method: .put, path: presignedURL)
        case let .createFeed(type, body):
            return Spec(
                method: .post,
                path: "/posts",
                queryParameters: [
                .type: "\(type)"
            ],
                bodyParametersEncodable: body
        )
        case let .createRealEmojiPresignedURL(memberId, body):
            return Spec(method: .post, path: "/members/\(memberId)/real-emoji/image-upload-request", bodyParametersEncodable: body)
        case let .createRealEmojiImage(memberId, body):
            return Spec(method: .post, path: "/members/\(memberId)/real-emoji", bodyParametersEncodable: body)
        case let .fetchRealEmojiImage(memberId):
            return Spec(method: .get, path: "/members/\(memberId)/real-emoji")
        case let .updateRealEmojiImage(memberId, realEmojiId, body):
            return Spec(method: .put, path: "/members/\(memberId)/real-emoji/\(realEmojiId)", bodyParametersEncodable: body)
        case .fetchTodayMission:
            return Spec(method: .get, path: "/missions/today")
            
        }
        
    }
    
    public final class Worker: BBRxAPIWorker {
        public init() { super.init() }
    }
    
}
