//
//  LinkWorker.swift
//  Data
//
//  Created by 마경미 on 28.11.24.
//

import Core

import RxSwift

typealias LinkWorker = LinkAPIs.Worker
extension LinkWorker {
    /// 가족 초대 링크를 생성하는 Method입니다.
    /// HTTP Method: POST
    /// - Parameters: familyId: String
    /// - Returns: CreateFamilyLinkResponseDTO?
    func createFamilyLink(
        _ familyId: String
    ) -> Observable<CreateFamilyLinkResponseDTO?> {
        let spec = LinkAPIs.createFamilyLink(familyId).spec
        
        return request(spec)
    }
}



