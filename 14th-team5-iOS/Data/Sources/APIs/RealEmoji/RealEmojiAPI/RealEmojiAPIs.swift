//
//  RealEmojiAPIS.swift
//  Data
//
//  Created by 마경미 on 22.01.24.
//

import Core
import Foundation

enum RealEmojiAPIs: API {
    case fetchRealEmojiList(FetchRealEmojiListParameter)
    case fetchMyRealEmoji
    case addRealEmoji(AddRealEmojiParameters)
    case removeRealEmoji(RemoveRealEmojiParameters)
    
    public var spec: APISpec {
        switch self {
        case .addRealEmoji(let parameter):
            let urlString = "\(BibbiAPI.hostApi)/posts/\(parameter.postId)/real-emoji"
            return APISpec(method: .post, url: urlString)
        case .fetchRealEmojiList(let parameter):
            let urlString = "\(BibbiAPI.hostApi)/posts/\(parameter.postId)/real-emoji"
            return APISpec(method: .get, url: urlString)
        case .fetchMyRealEmoji:
            let memberId = App.Repository.member.memberID.value
            let urlString = "\(BibbiAPI.hostApi)/members/\(memberId ?? "")/real-emoji"
            return APISpec(method: .get, url: urlString)
        case .removeRealEmoji(let parameter):
            let urlString = "\(BibbiAPI.hostApi)/posts/\(parameter.postId)/real-emoji/\(parameter.realEmojiId)"
            return APISpec(method: .delete, url: urlString)
        }
    }
}

enum PostRealEmojiAPI: BBAPI {
    /// 게시물에 리얼 이모지 등록
    case addRealEmojiReaction(_ postId: String)
    /// 게시물에서 리얼 이모지 삭제
    case removeRealEmojiReactions(_ postId: String, _ realEmojiId: String)
    /// 게시물의 리얼 이모지 전체 조회
    case fetchRealEomjiReactions(_ postId: String)
    
    var spec: Spec {
        switch self {
        case .addRealEmojiReaction(let postId):
            return .init(method: .post, path: "/posts/\(postId)/real-emoji")
        case .removeRealEmojiReactions(let postId, let realEmojiId):
            return .init(method: .delete, path: "/posts/\(postId)/real-emoji/\(realEmojiId)")
        case .fetchRealEomjiReactions(let postId):
            return .init(method: .get, path: "/posts/\(postId)/real-emoji")
        }
    }
}

enum MemberRealEmojiAPI: BBAPI {
    struct UploadRealEmojiRequest: Encodable {
        let imageName: String
    }
    
    /// 회원의 리얼 이모지 조회
    case fetchMemberRealEmoji(_ memberId: String)
    /// 회원의 리얼 이모지 추가
    case addMemberRealEmoji(_ mbmerId: String)
    /// 회원의 리얼 이모지 변경
    case updateMemberRealEmoji(_ memberId: String)
    /// 리얼 이모지 사진 presigned url 요청
    case uploadRealEmoji(_ mebmerId: String, _ body: UploadRealEmojiRequest)
    
    var spec: Spec {
        switch self {
        case .fetchMemberRealEmoji(let memberId):
            return .init(method: .get, path: "/members/\(memberId)/real-emoji")
        case .addMemberRealEmoji(let memberId):
            return .init(method: .post, path: "/members/\(memberId)/real-emoji")
        case .updateMemberRealEmoji(let memberId):
            return .init(method: .put, path: "/members/\(memberId)/real-emoji")
        case .uploadRealEmoji(let memberId, let body):
            return .init(method: .post, path: "/members/\(memberId)/real-emoji/image-upload-request"
)
        }
    }
}
