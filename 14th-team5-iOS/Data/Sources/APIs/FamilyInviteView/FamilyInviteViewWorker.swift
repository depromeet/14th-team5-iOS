//
//  FamilyInviteViewWorker.swift
//  Data
//
//  Created by 마경미 on 27.11.24.
//

import RxSwift

typealias FamilyInviteViewWorker = FamilyInviteViewAPIs.Worker
extension FamilyInviteViewWorker {
    /// 가족방 초대 링크를 조회하기 위한 Method입니다.
    /// HTTP Method: GET
    /// - Parameters: familyId: String
    /// - Returns: FamilyInvitationLinkResponseDTO?
    func fetchInvitationLink(
        familyId: String
    ) -> Observable<FamilyInvitationLinkResponseDTO?> {
        let spec = FamilyInviteViewAPIs.fetchFamilyInfoWithLink(familyId).spec
        
        return request(spec)
    }
}
