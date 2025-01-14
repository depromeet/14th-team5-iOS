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
    private let disposeBag = DisposeBag()
    
    // MARK: - APIWorker
    private let meAPIWorker = MeeAPIWorker()

    // MARK: - UserDefaults
    private let appUserDefaults = AppUserDefaults()
    
    // MARK: - Intializer
    public init() { }
    
}


// MARK: - Extensions

extension AppRepository {
    
    public func fetchAppVersion() -> Observable<AppVersionEntity> {
        // TODO: - xAppKey 불러오는 코드 다시 작성하기
        let appKey = "4c9b1c45-9dba-4813-b7c0-b079c08befe6"
        
        return meAPIWorker.fetchAppVersion(appKey: appKey)
            .map { $0.toDomain() }
    }
    
    public func loadIsFirstFamilyManagement() -> RxSwift.Observable<Bool?> {
        let isFirstFamily = appUserDefaults.loadIsFirstFamilyManagement()
        return .just(isFirstFamily)
    }
    
    public func saveIsFirstFamilyManagement(isFirst: Bool) {
        appUserDefaults.saveIsFirstFamilyManagement(isFirst)
    }
    
    public func loadIsFirstWidgetAlert() -> Observable<Bool?> {
        let isFirstWidgetAlert = appUserDefaults.loadIsFirstShowWidgetAlert()
        return .just(isFirstWidgetAlert)
    }
    
    public func saveIsFirstWidgetAlert(isFirst: Bool) {
        appUserDefaults.saveIsFirstShowWidgetAlert(isFirst)
    }
}
