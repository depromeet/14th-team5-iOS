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
    public func fetchMain() -> Observable<MainViewEntity?> {
        return mainApiWorker.fetchMain()
            .map { $0?.toDomain() }
            .do(onSuccess: { [weak self] in
                guard 
                    let self,
                    let profiles = $0?.mainFamilyProfileDatas else {
                    return
                }
                self.familyUserDefaults.saveFamilyMembers(profiles)
            })
            .asObservable()
    }
    
    public func fetchMainNight() -> Observable<NightMainViewEntity?> {
        return mainApiWorker.fetchMainNight()
            .map { $0?.toDomain() }
            .do(onSuccess: { [weak self] in
                guard
                    let self,
                    let profiles = $0?.mainFamilyProfileDatas else {
                    return
                }
                self.familyUserDefaults.saveFamilyMembers(profiles)
            })
            .asObservable()
    }
}
