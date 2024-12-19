//
//  SignInUseCase.swift
//  Domain
//
//  Created by 김건우 on 6/15/24.
//

import Foundation

import RxSwift

public protocol SignInUseCaseProtocol {
    func execute(_ type: SignInType, body: NativeSocialLoginRequest) -> Observable<AuthResultEntity>
}

public class SignInUseCase: SignInUseCaseProtocol {
    
    // MARK: - Repositories
    private var oauthRepository: OAuthRepositoryProtocol
    
    // MARK: - Intializer
    public init(oauthRepository: OAuthRepositoryProtocol) {
        self.oauthRepository = oauthRepository
    }
    
    // MARK: - Execute
    public func execute(
        _ type: SignInType,
        body: NativeSocialLoginRequest
    ) -> Observable<AuthResultEntity> {
        return oauthRepository.signIn(type, body: body)
    }
}
