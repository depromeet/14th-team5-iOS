//
//  SocialSignInUsecase.swift
//  Domain
//
//  Created by 김건우 on 6/15/24.
//

import Foundation

import RxSwift

public protocol SocialSignInUseCaseProtocol {
    func execute(with type: SignInType, on window: AnyObject?) -> Observable<TokenResultEntity?>
}

public final class SocialSignInUseCase: SocialSignInUseCaseProtocol {
    
    // MARK: - Repositories
    private var signInRepository: SignInRepositoryProtocol
    
    // MARK: - Intializer
    public init(signInRepository: SignInRepositoryProtocol) {
        self.signInRepository = signInRepository
    }
    
    // MARK: - Execute
    public func execute(
        with type: SignInType,
        on window: AnyObject?
    ) -> Observable<TokenResultEntity?> {
        return signInRepository.signIn(with: type, on: window)
    }
    
}
