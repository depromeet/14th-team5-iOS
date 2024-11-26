//
//  AddFamiliyAPIWorker.swift
//  Data
//
//  Created by 김건우 on 12/20/23.
//

import Core

import RxSwift

typealias FamilyAPIWorker = FamilyAPIs.Worker
extension FamilyAPIWorker {
    func fetchFamilyCreatedAt(
        _ familyId: String
    ) -> Observable<FamilyCreatedAtResponseDTO?> {
        let spec = FamilyAPIs.fetchFamilyCreatedAt(familyId).spec
        
        return request(spec)
    }
    
    func updateFamilyName(
        _ familyId: String,
        body: UpdateFamilyNameRequestDTO
    ) -> Observable<FamilyNameResponseDTO?> {
        let spec = FamilyAPIs.updateFamilyName(familyId).spec
        
        return request(spec)
    }
}



