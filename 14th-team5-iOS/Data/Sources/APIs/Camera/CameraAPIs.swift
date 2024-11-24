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
    /// S3 Bucket 업로드 API
    case uploadTos3Bucket(presignedURL: String)
    /// 리얼 이모지 Presigned URL 요청 API
    case createRealEmojiPresignedURL(memberID: String, body: CreatePresignedURLReqeustDTO)
    /// 리얼 이미지 추가 API
    case createRealEmojiImage(memberId: String, body: CreateEmojiImageReqeustDTO)
    /// 리얼 이미지 조회 API
    case fetchRealEmojiImage(memberId: String)
    /// 리얼 이모지 수정 API
    case updateRealEmojiImage(memberId: String, realEmojiId: String, body: UpdateRealEmojiImageRequestDTO)
    
    var spec: Spec {
        switch self {
        case let .uploadTos3Bucket(presignedURL):
            return Spec(method: .put, path: presignedURL)
        case let .createRealEmojiPresignedURL(memberId, body):
            return Spec(method: .post, path: "/members/\(memberId)/real-emoji/image-upload-request", bodyParametersEncodable: body)
        case let .createRealEmojiImage(memberId, body):
            return Spec(method: .post, path: "/members/\(memberId)/real-emoji", bodyParametersEncodable: body)
        case let .fetchRealEmojiImage(memberId):
            return Spec(method: .get, path: "/members/\(memberId)/real-emoji")
        case let .updateRealEmojiImage(memberId, realEmojiId, body):
            return Spec(method: .put, path: "/members/\(memberId)/real-emoji/\(realEmojiId)", bodyParametersEncodable: body)
            
        }
        
    }
    
    public final class Worker: BBRxAPIWorker {
        public init() { super.init() }
    }
    
}
