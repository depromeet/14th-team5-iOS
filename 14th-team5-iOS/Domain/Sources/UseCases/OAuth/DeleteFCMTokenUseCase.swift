//
//  DeleteFCMTokenUseCase.swift
//  Domain
//
//  Created by 김건우 on 6/15/24.
//

import Foundation

import RxSwift

public protocol DeleteFCMTokenUseCaseProtocol {
    func execute() -> Observable<DefaultEntity>
}

public class DeleteFCMTokenUseCase: DeleteFCMTokenUseCaseProtocol {
    
    // MARK: - Repositories
    private var oauthRepository: OAuthRepositoryProtocol
    
    // MARK: - Intializer
    public init(oauthRepository: OAuthRepositoryProtocol) {
        self.oauthRepository = oauthRepository
    }
    
    // MARK: - Execute
    public func execute() -> Observable<DefaultEntity> {
        return oauthRepository.deleteFCMToken()
    }
}

