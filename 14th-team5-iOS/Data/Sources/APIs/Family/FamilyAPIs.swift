//
//  AddFamiliyAPI.swift
//  Data
//
//  Created by 김건우 on 12/20/23.
//

import Core

enum FamilyAPIs: BBAPI {
    /// 가족 생성
    case createFamily
    /// 가족 그룹 생성 시간 조회
    case fetchFamilyCreatedAt(_ familyId: String)
    /// 가족 이름 변경
    case updateFamilyName(_ familyId: String, body: UpdateFamilyNameRequestDTO)
    
    var spec: Spec {
        switch self {
        case .createFamily:
            return .init(
                method: .post,
                path: "/families"
            )
        case .fetchFamilyCreatedAt(let familyId):
            return .init(
                method: .get,
                path: "/families/\(familyId)/created-at"
            )
        case .updateFamilyName(let familyId, let body):
            return .init(
                method: .put,
                path: "/families/\(familyId)/name",
                bodyParametersEncodable: body
            )
        }
    }
    
    final class Worker: BBRxAPIWorker {
        init() { }
    }
}
