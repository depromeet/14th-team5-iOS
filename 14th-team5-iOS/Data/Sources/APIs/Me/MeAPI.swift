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
    case joinFamily
    /// 가족 탈퇴하기
    case resignFamily
    /// 가족 생성 및 가족 정보 조회
    case createFamily
    /// 내 가족 정보 조회
    case fetchFamilyInfo
    
    var spec: Spec {
        switch self {
        case .joinFamily:
            return .init(method: .post, path: "/me/join-family")
        case .resignFamily:
            return .init(method: .post, path: "/me/quit-family")
        case .createFamily:
            return .init(method: .post, path: "/me/create-family")
        case .fetchFamilyInfo:
            return .init(method: .get, path: "/me/family-info")
        }
    }
    
    final class Worker: BBRxAPIWorker {
        init() { }
    }
}
