//
//  AddFamiliyAPIWorker.swift
//  Data
//
//  Created by 김건우 on 12/20/23.
//

import Core

import RxSwift

typealias FamilyWorker = FamilyAPIs.Worker
extension FamilyWorker {
    /// 가족이 생성된 날짜를 조회하기 위한 Method입니다.
    /// HTTP Method: GET
    /// - Parameters: familyId: String
    /// - Returns: FamilyCreatedAtResponseDTO?
    func fetchFamilyCreatedAt(
        _ familyId: String
    ) -> Observable<FamilyCreatedAtResponseDTO?> {
        let spec = FamilyAPIs.fetchFamilyCreatedAt(familyId).spec
        
        return request(spec)
    }
    
    /// 가족방 이름을 변경하기 위한 Method입니다.
    /// HTTP Method: POST
    /// - Parameters: familyId: String, body: UpdateFamilyNameRequestDTO
    /// - Returns: FamilyNameResponseDTO?
    func updateFamilyName(
        _ familyId: String,
        body: UpdateFamilyNameRequestDTO
    ) -> Observable<FamilyNameResponseDTO?> {
        let spec = FamilyAPIs.updateFamilyName(familyId).spec
        
        return request(spec)
    }
}



