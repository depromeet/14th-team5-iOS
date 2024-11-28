//
//  FamilyInviteViewAPIs.swift
//  Data
//
//  Created by 마경미 on 27.11.24.
//

import Core

enum FamilyInviteViewAPIs: BBAPI {
    /// 가족 초대 링크 정보 조회
    /// 토근 O: 가족 가입 프로세스 앱 페이지용 정보 조회로 이동합니다.
    /// 토근 X: 딥링크 웹뷰 페이지용 정보 조회로 이동합니다.
    case fetchFamilyInfoWithLink(_ linkId: String)
    
    var spec: Spec {
        switch self {
        case .fetchFamilyInfoWithLink(let linkId):
            return .init(method: .get, path: "/view/family-invite/\(linkId)")
        }
    }
    
    final class Worker: BBRxAPIWorker {
        init() { }
    }
}
