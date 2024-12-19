//
//  MainAPIWorker.swift
//  Data
//
//  Created by 마경미 on 20.04.24.
//

import Foundation

import Core
import Domain

import RxSwift

typealias MainAPIWorker = MainViewAPIs.Worker

extension MainAPIWorker {
    /// 생존신고 활성화 시간에 main 화면 데이터를 조회하기 위한 Method입니다.
    /// HTTP Method: GET
    /// - Returns: MainResponseDTO
    func fetchMain() -> Observable<MainResponseDTO> {
        let spec = MainViewAPIs.fetchMain.spec
        return request(spec)
    }
    
    /// 생존신고 비활성화 시간에 main 화면 데이터를 조회하기 위한 Method입니다.
    /// HTTP Method: GET
    /// - Returns: MainNightResponseDTO
    func fetchMainNight() -> Observable<MainNightResponseDTO> {
        let spec = MainViewAPIs.fetchMainNight.spec
        return request(spec)
    }
}
