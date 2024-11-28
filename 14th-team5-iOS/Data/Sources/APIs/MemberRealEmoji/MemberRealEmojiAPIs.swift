//
//  MemberRealEmojiAPIs.swift
//  Data
//
//  Created by 마경미 on 26.11.24.
//

import Core

enum MemberRealEmojiAPIs: BBAPI {
    /// 회원의 리얼 이모지 조회
    case fetchMemberRealEmoji(_ memberId: String)
    /// 회원의 리얼 이모지 추가
    case addMemberRealEmoji(_ mbmerId: String)
    /// 회원의 리얼 이모지 변경
    case updateMemberRealEmoji(_ memberId: String)
    /// 리얼 이모지 사진 presigned url 요청
    case uploadRealEmoji(_ mebmerId: String, _ body: UploadRealEmojiRequestDTO)
    
    var spec: Spec {
        switch self {
        case .fetchMemberRealEmoji(let memberId):
            return .init(method: .get, path: "/members/\(memberId)/real-emoji")
        case .addMemberRealEmoji(let memberId):
            return .init(method: .post, path: "/members/\(memberId)/real-emoji")
        case .updateMemberRealEmoji(let memberId):
            return .init(method: .put, path: "/members/\(memberId)/real-emoji")
        case .uploadRealEmoji(let memberId, let body):
            return .init(
                method: .post,
                path: "/members/\(memberId)/real-emoji/image-upload-request",
                bodyParametersEncodable: body
            )
        }
    }
    
    final class Worker: BBRxAPIWorker {
        init() { }
    }
}
