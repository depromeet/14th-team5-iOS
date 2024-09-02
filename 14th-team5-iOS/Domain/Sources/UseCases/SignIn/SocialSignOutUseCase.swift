//
//  SocialSignOutUseCase.swift
//  Domain
//
//  Created by 김건우 on 6/15/24.
//

import Foundation

import RxSwift

public protocol SocialSignOutUseCaseProtocol {
    func execute() -> Completable
}

public final class SocialSignOutUseCase: SocialSignOutUseCaseProtocol {
    
    // MARK: - Repositories
    private var signInRepository: SignInRepositoryProtocol
    
    // MARK: - Intializer
    public init(signInRepository: SignInRepositoryProtocol) {
        self.signInRepository = signInRepository
    }
    
    // MARK: - Execute
    public func execute() -> Completable {
        return signInRepository.signOut()
    }
    
}

