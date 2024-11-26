//
//  FamilyInviteViewWorker.swift
//  Data
//
//  Created by 마경미 on 27.11.24.
//

import RxSwift

typealias FamilyInviteViewWorker = FamilyInviteViewAPIs.Worker
extension FamilyInviteViewWorker {
    func fetchInvitationLink(familyId: String) -> Observable<FamilyInvitationLinkResponseDTO?> {
        let spec = FamilyInviteViewAPIs.fetchFamilyInfoWithLink(familyId).spec
        
        return request(spec)
    }
}
