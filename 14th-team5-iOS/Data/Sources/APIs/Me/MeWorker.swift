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
    /// 가족방 탈퇴를 위한 Method입니다.
    /// HTTP Method: Post
    /// - Returns: DefaultResponseDTO?
    func resignFamily() -> Observable<DefaultResponseDTO?> {
        let spec = MeAPI.resignFamily.spec
        
        return request(spec)
    }
    
    /// 가족방을 생성하기 위한 Method입니다.
    /// HTTP Method: Post
    /// - Returns: CreateFamilyResponseDTO?
    func createFamily() -> Observable<CreateFamilyResponseDTO?> {
        let spec = MeAPI.createFamily.spec
        
        return request(spec)
    }

    /// 가족방에 참여하기 위한 Method입니다.
    /// HTTP Method: Post
    /// - Parameters: body: JOinFamilyRequestDTO
    /// - Returns: JoinFamilyResponseDTO?
    func joinFamily(
        body: JoinFamilyRequestDTO
    ) -> Observable<JoinFamilyResponseDTO?> {
        let spec = MeAPI.joinFamily.spec
        
        return request(spec)
    }
    
    /// 가족 기본 정보를 조회하기 위한 Method입니다.
    /// HTTP Method: GET
    /// - Returns: FamilyGroupInfoResponseDTO?
    func fetchFamilyInfo() -> Observable<FamilyInfoResponseDTO?> {
        let spec = MeAPI.fetchFamilyInfo.spec
        
        return request(spec)
    }
}
