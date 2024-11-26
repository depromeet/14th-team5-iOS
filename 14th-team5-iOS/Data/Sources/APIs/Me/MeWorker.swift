//
//  MeWorker.swift
//  Data
//
//  Created by 마경미 on 27.11.24.
//

import Core

import RxSwift

// TODO: MeWorker로 이름 바꾸기
typealias MeeWorker = MeAPI.Worker
extension MeeWorker {
    func resignFamily() -> Observable<DefaultResponseDTO?> {
        let spec = MeAPI.resignFamily.spec
        
        return request(spec)
    }
    
    func createFamily() -> Observable<CreateFamilyResponseDTO?> {
        let spec = MeAPI.createFamily.spec
        
        return request(spec)
    }

    func joinFamily(body: JoinFamilyRequestDTO) -> Observable<JoinFamilyResponseDTO?> {
        let spec = MeAPI.joinFamily.spec
        
        return request(spec)
    }
    
    func fetchFamilyInfo() -> Observable<FamilyGroupInfoResponseDTO?> {
        let spec = MeAPI.fetchFamilyInfo.spec
        
        return request(spec)
    }
}
