//
//  MainRepository.swift
//  Data
//
//  Created by 마경미 on 20.04.24.
//

import Foundation

import Domain

import RxSwift

public final class MainViewRepository: MainViewRepositoryProtocol {
    public let disposeBag: DisposeBag = DisposeBag()
    
    private let familyUserDefaults: FamilyInfoUserDefaults = FamilyInfoUserDefaults()
    private let mainApiWorker: MainAPIWorker = MainAPIWorker()
    
    public init() { }
}

extension MainViewRepository {
    public func fetchMain() -> Observable<MainViewEntity> {
        return mainApiWorker.fetchMain()
            .flatMap { [weak self] response -> Observable<MainViewEntity> in
                guard let self else {
                    return Observable.error(
                        NSError(domain: "MainError", code: -1, userInfo: nil)
                    )
                }
                let entities = response.toDomain()
                let profiles = entities.mainFamilyProfileDatas
                self.familyUserDefaults.saveFamilyMembers(profiles)
                return Observable.just(entities)
            }
    }
    
    public func fetchMainNight() -> Observable<NightMainViewEntity> {
        return mainApiWorker.fetchMainNight()
            .flatMap { [weak self] response -> Observable<NightMainViewEntity> in
                guard let self else {
                    return Observable.error(
                        NSError(domain: "MainError", code: -1, userInfo: nil)
                    )
                }
                let entities = response.toDomain()
                let profiles = entities.mainFamilyProfileDatas
                self.familyUserDefaults.saveFamilyMembers(profiles)
                return Observable.just(entities)
            }
    }
}
