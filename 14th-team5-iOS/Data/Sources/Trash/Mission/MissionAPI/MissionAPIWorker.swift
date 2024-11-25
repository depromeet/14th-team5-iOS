//
//  MissionAPIWorker.swift
//  Data
//
//  Created by 마경미 on 21.04.24.
//

import Foundation

import Core
import Domain

import RxSwift

typealias MissionAPIWorker = MissionAPIs.Worker

extension MissionAPIWorker {
    
    /// 미션 정보를 조회하기 위한 API 입니다.
    /// HTTP Method : GET
    /// - Parameters : missonid(미션 ID)
    /// - Returns : MissionContentResponseDTO
    func fetchMissonContent(missonId: String) -> Observable<MissionContentResponseDTO?> {
        let spec = MissionAPIs.fetchMissonContent(missonId: missonId).spec
        
        return request(spec)
    }
    
    /// 미션 일일 정보를 조회하기 위한 API 입니다.
    /// HTTP Method : GET
    /// - Returns : CameraTodayMissionResponseDTO
    func fetchDailyMisson() -> Observable<CameraTodayMissionResponseDTO?> {
        let spec = MissionAPIs.fetchDailyMisson.spec
        
        return request(spec)
    }
}
