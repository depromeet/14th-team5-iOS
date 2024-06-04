//
//  MainRepository.swift
//  Data
//
//  Created by 마경미 on 20.04.24.
//

import Foundation

import Domain

import RxSwift

public final class MainViewRepository: MainRepositoryProtocol {
    public let disposeBag: DisposeBag = DisposeBag()
    
    private let mainApiWorker: MainAPIWorker = MainAPIWorker()
    
    public init() { }
}

extension MainViewRepository {
    public func fetchMain() -> Observable<MainData?> {
        return mainApiWorker.fetchMain()
            .asObservable()

    }
    
    public func fetchMainNight() -> Observable<MainNightData?> {
        return mainApiWorker.fetchMainNight()
            .asObservable()
    }
}
