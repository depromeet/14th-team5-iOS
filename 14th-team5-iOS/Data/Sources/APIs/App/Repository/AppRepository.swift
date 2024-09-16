//
//  AppRepository.swift
//  Data
//
//  Created by 김건우 on 7/10/24.
//

import Domain
import Foundation

import RxSwift

public final class AppRepository: AppRepositoryProtocol {

    // MARK: - Properties
    public let disposeBag = DisposeBag()
    
    // MARK: - APIWorker
    private let appApiWorker = AppAPIWorker()

    // MARK: - UserDefaults
    private let appUserDefaults = AppUserDefaults()
    
    // MARK: - Intializer
    public init() { }
    
}


// MARK: - Extensions

extension AppRepository {
    
    public func fetchAppVersion() -> Observable<AppVersionEntity?> {
        // TODO: - xAppKey 불러오는 코드 다시 작성하기
        let appKey = "7c5aaa36-570e-491f-b18a-26a1a0b72959"
        
        return appApiWorker.fetchAppVersion(appKey: appKey)
            .map { $0?.toDomain() }
            .asObservable()
    }
    
    public func fetchisFirstFamilyManagement() -> RxSwift.Observable<Bool> {
        let isFirstFamily = appUserDefaults.loadIsFirstFamilyManagement()
        return .just(isFirstFamily)
    }
    
    public func saveIsFirstFamilyManagement(isFirst: Bool) {
        appUserDefaults.saveIsFirstFamilyManagement(isFirst)
    }
}
