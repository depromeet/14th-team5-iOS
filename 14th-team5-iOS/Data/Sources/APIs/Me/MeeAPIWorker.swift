//
//  MeWorker.swift
//  Data
//
//  Created by 마경미 on 27.11.24.
//

import Core

import RxSwift

// TODO: MeWorker로 이름 바꾸기
typealias MeeAPIWorker = MeAPI.Worker
extension MeeAPIWorker {
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
        let spec = MeAPI.joinFamily(body).spec
        
        return request(spec)
    }
    
    /// 가족 기본 정보를 조회하기 위한 Method입니다.
    /// HTTP Method: GET
    /// - Returns: FamilyGroupInfoResponseDTO?
    func fetchFamilyInfo() -> Observable<FamilyInfoResponseDTO?> {
        let spec = MeAPI.fetchFamilyInfo.spec
        
        return request(spec)
    }
    
    /// FCM 토큰을 등록하기 위한 Method입니다.
    /// HTTP Method: POST
    /// - parameters: body: AddFCMTokenRequestDTO
    /// - Returns: DefaultResponseDTO
    func registerNewFCMToken(
        body: AddFCMTokenRequestDTO
    ) -> Observable<DefaultResponseDTO> {
        let spec = MeAPI.registerFCMToken.spec
        
        return request(spec)
    }
    
    
    /// 등록된 FCM 토큰을 삭제하기 위한 Method입니다.
    /// HTTP Method: Delete
    /// - parameters: token: String
    /// - Returns: DefaultResponseDTO
    func deleteFCMToken(
        fcmToken token: String
    ) -> Observable<DefaultResponseDTO> {
        let spec = MeAPI.deleteFCMToken(token).spec
        
        return request(spec)
    }
    
    /// 현재 설치된 앱 버전 정보를 조회하기 위한 Method입니다.
    /// HTTP Method: Get
    /// - parameters: appKey: String
    /// - Returns: AppVersionResponseDTO
    func fetchAppVersion(
        appKey: String
    ) -> Observable<AppVersionResponseDTO> {
        let spec = MeAPI.appVersion(appKey).spec
        
        return request(spec)
    }
}
