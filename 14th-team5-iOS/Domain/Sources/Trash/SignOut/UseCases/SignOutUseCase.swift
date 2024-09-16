//
//  SignOutUseCase.swift
//  Domain
//
//  Created by 마경미 on 22.02.24.
//

import Foundation

import RxSwift

public protocol SignOutUseCaseProtocol {
    func execute() -> Single<Void?>
}


public class SignOutUseCase: SignOutUseCaseProtocol {
    //FIXME: - Repository 분리
    //FIXME: - SocialSignOutUse로 로직 수정
    private let keychainRepository: KeychainRepositoryProtocol
    private let userDefaultsRepository: UserDefaultsRepositoryProtocol
    private let fcmRepository: FCMRepositoryProtocol
    
    public init(keychainRepository: KeychainRepositoryProtocol, userDefaultsRepository: UserDefaultsRepositoryProtocol, fcmRepository: FCMRepositoryProtocol) {
        self.keychainRepository = keychainRepository
        self.userDefaultsRepository = userDefaultsRepository
        self.fcmRepository = fcmRepository
    }
    
    public func execute() -> Single<Void?> {
        return fcmRepository.deleteFCMToken()
             .flatMap { _ -> Single<Void?> in
                 self.keychainRepository.removeKeychain()
                 self.userDefaultsRepository.removeUserDefaultsWhenSignOut()
                 return Single.just(nil)
             }
    }
}
