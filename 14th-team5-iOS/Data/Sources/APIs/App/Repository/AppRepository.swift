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
        let appKey = "7b159d28-b106-4b6d-a490-1fd654ce40c2"
        
        return appApiWorker.fetchAppVersion(appKey: appKey)
            .map { $0?.toDomain() }
            .asObservable()
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
