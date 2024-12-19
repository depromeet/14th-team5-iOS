//
//  RefreshAccessTokenUseCase.swift
//  Domain
//
//  Created by 김건우 on 6/15/24.
//

import Foundation

import RxSwift

public protocol RefreshAccessTokenUseCaseProtocol {
    func execute(body: RefreshAccessTokenRequest) -> Observable<AuthResultEntity>
}

public final class RefreshAccessTokenUseCase: RefreshAccessTokenUseCaseProtocol {
    
    // MARK: - Repositories
    private var oauthRepository: OAuthRepositoryProtocol
    
    // MARK: - Intializer
    public init(oauthRepository: OAuthRepositoryProtocol) {
        self.oauthRepository = oauthRepository
    }
    
    // MARK: - Execute
    public func execute(body: RefreshAccessTokenRequest) -> Observable<AuthResultEntity> {
        return oauthRepository.refreshAccessToken(body: body)
    }
}
