//
//  AddFamiliyAPI.swift
//  Data
//
//  Created by 김건우 on 12/20/23.
//

import Core
import Foundation

enum FamilyAPIs: API {
    case joinFamily
    case createFamily
    case resignFamily
    case fetchInvitationLink(String)
    case fetchFamilyCreatedAt(String)
    case fetchPaginationFamilyMembers(Int, Int)
    case updateFamilyName(String)
    case fetchFamilyInfo

    var spec: APISpec {
        switch self {
        case .joinFamily:
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/me/join-family")
        case .resignFamily:
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/me/quit-family")
        case .createFamily:
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/me/create-family")
        case let .fetchInvitationLink(familyId):
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/links/family/\(familyId)")
        case let .fetchFamilyCreatedAt(familyId):
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/families/\(familyId)/created-at")
        case let .fetchPaginationFamilyMembers(page, size):
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/members?type=FAMILY&page=\(page)&size=\(size)")
        case let .updateFamilyName(familyId):
            return APISpec(method: .put, url: "\(BibbiAPI.hostApi)/families/\(familyId)/name")
        case .fetchFamilyInfo:
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/me/family-info")
        }
    }
}


enum FamilyAPI: BBAPI {
    /// 가족 생성
    case createFamily
    /// 가족 그룹 생성 시간 조회
    case fetchFamilyCreatedAt(_ familyId: Int)
    /// 가족 이름 변경
    case updateFamilyName(_ familyId: Int)
    
    var spec: Spec {
        switch self {
        case .createFamily:
            return .init(method: .post, path: "/families")
        case .fetchFamilyCreatedAt(let familyId):
            return .init(method: .get, path: "/\(familyId)/created-at")
        case .updateFamilyName(let familyId):
            return .init(method: .put, path: "/\(familyId)/name")
        }
    }
}

enum FamilyInviteViewAPI: BBAPI {
    /// 가족 초대 링크 정보 조회
    /// 토근 O: 가족 가입 프로세스 앱 페이지용 정보 조회
    /// 토근 X: 딥링크 웹뷰 페이지용 정보 조회
    case fetchFamilyInfoWithLink(_ linkId: String)
    
    var spec: Spec {
        switch self {
        case .fetchFamilyInfoWithLink(let linkId):
            return .init(method: .get, path: "/view/family-invite/\(linkId)")
        }
    }
}

enum MeAPI: BBAPI {
    /// 가족 가입하기
    case joinFamily
    /// 가족 탈퇴하기
    case resignFamily
    /// 가족 생성 및 가족 정보 조회
    case createFamily
    
    var spec: Spec {
        switch self {
        case .joinFamily:
            return .init(method: .post, path: "/me/join-family")
        case .resignFamily:
            return .init(method: .post, path: "/me/quit-family")
        case .createFamily:
            return .init(method: .post, path: "/me/create-family")
        }
    }
}

enum MembersAPI: BBAPI {
    struct FamilyMemberQuery: Encodable {
        let type: String
        let page: Int?
        let size: Int?
    }
    
    /// 가족 구성원 프로필 조회
    case fetchFamilyMembers(_ query: FamilyMemberQuery)
    
    var spec: Spec {
        switch self {
        case .fetchFamilyMembers(let query):
            return .init(method: .get, path: "/members", queryParametersEncodable: query)
        }
    }
}
