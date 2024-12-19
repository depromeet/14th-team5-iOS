//
//  RegisterNewFCMTokenUseCase.swift
//  Domain
//
//  Created by 김건우 on 6/15/24.
//

import Foundation

import RxSwift

public protocol RegisterNewFCMTokenUseCaseProtocol {
    func execute(body: AddFCMTokenRequest) -> Observable<DefaultEntity>
}

public class RegisterNewFCMTokenUseCase: RegisterNewFCMTokenUseCaseProtocol {
    
    // MARK: - Repositories
    private var oauthRepository: OAuthRepositoryProtocol
    
    // MARK: - Intializer
    public init(oauthRepository: OAuthRepositoryProtocol) {
        self.oauthRepository = oauthRepository
    }
    
    // MARK: - Execute
    public func execute(body: AddFCMTokenRequest) -> Observable<DefaultEntity> {
        return oauthRepository.registerNewFCMToken(body: body)
    }
}

