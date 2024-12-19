//
//  MeAPIs.swift
//  Data
//
//  Created by 마경미 on 27.11.24.
//

import Core

// TODO: MeAPIs로 이름 바꾸기 - Trash 지워야 함
enum MeAPI: BBAPI {
    /// 가족 가입하기
    case joinFamily(_ body: JoinFamilyRequestDTO)
    /// 가족 탈퇴하기
    case resignFamily
    /// 가족 생성 및 가족 정보 조회
    case createFamily
    /// 내 가족 정보 조회
    case fetchFamilyInfo
    /// fcm 토큰 등록
    case registerFCMToken
    /// fcm 토큰 삭제
    case deleteFCMToken(_ token: String)
    /// 내 접속 버전 조회
    case appVersion(_ appKey: String)
    
    var spec: Spec {
        switch self {
        case let .joinFamily(body):
            return .init(
                method: .post,
                path: "/me/join-family",
                bodyParametersEncodable: body
            )
        case .resignFamily:
            return .init(   
                method: .post,
                path: "/me/quit-family"
            )
        case .createFamily:
            return .init(
                method: .post,
                path: "/me/create-family"
            )
        case .fetchFamilyInfo:
            return .init(
                method: .get,
                path: "/me/family-info"
            )
        case .registerFCMToken:
            return .init(
                method: .post,
                path: "/me/fcm"
            )
        case let .deleteFCMToken(token):
            return .init(
                method: .delete,
                path: "/me/fcm/\(token)"
            )
        case let .appVersion(version):
            return .init(
                method: .get,
                path: "/me/app-version",
                queryParameters: [
                    "appKey": "\(version)"
                ]
            )
        }
    }
    
    final class Worker: BBRxAPIWorker {
        init() { }
    }
}
