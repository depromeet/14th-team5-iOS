//
//  LinkAPIs.swift
//  Data
//
//  Created by 마경미 on 28.11.24.
//

import Core

enum LinkAPIs: BBAPI {
    /// 가족 링크 생성
    case createFamilyLink(_ familyId: String)
    
    var spec: Spec {
        switch self {
        case let .createFamilyLink(familyId):
            return .init(
                method: .post,
                path: "/links/family/\(familyId)"
            )
        }
    }
    
    final class Worker: BBRxAPIWorker {
        init() { }
    }
}
