//
//  MembersAPIs.swift
//  Data
//
//  Created by Kim dohyun on 6/5/24.
//

import Foundation

import Core



enum MembersAPIs: BBAPI {
    /// 회원 프로필 조회 API
    case fetchMember(memberId: String)
    /// 회원 탈퇴 API
    case deleteMember(memberId: String, body: DeleteMemberRequestDTO)
    /// 회원 콕 찌르기 API
    case createMemberPick(memberId: String)
    /// 회원 프로필 Presigend URL 요청 API
    case createMemberPresignedURL
    /// 회원 이름 수정 API
    case updateMemberName(memberId: String, body: UpdateMemberNameRequestDTO)
    /// 회원 프로필 이미지 수정 API
    case updateMemberProfileImage(memberId: String)
    /// 회원 프로필 이미지 삭제 API
    case deleteMemberProfileImage(memberId: String)
    

    var spec: Spec {
        switch self {
        case let .fetchMember(memberId):
            return Spec(method: .get, path: "/members/\(memberId)")
        case let .deleteMember(memberId, body):
            return Spec(method: .delete, path: "/members/\(memberId)", bodyParametersEncodable: body)
        case let .createMemberPick(memberId):
            return Spec(method: .post, path: "/members/\(memberId)/pick")
        case .createMemberPresignedURL:
            return Spec(method: .post, path: "/members/image-upload-request") //TODO: RequestBody 추가
        case let .updateMemberName(memberId, body):
            return Spec(method: .put, path: "/members/name/\(memberId)", bodyParametersEncodable: body)
        case let .updateMemberProfileImage(memberId):
            return Spec(method: .put, path: "/members/profile-image-url/\(memberId)") //TODO: RequestBody 추가
        case let .deleteMemberProfileImage(memberId):
            return Spec(method: .delete, path: "/members/profile-image-url/\(memberId)")
        }
    }
    
    
    final class Worker: BBRxAPIWorker {
        init() { }
    }
}

