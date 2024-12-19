//
//  RegisterNewMemberUseCase.swift
//  Domain
//
//  Created by 김건우 on 6/15/24.
//

import Foundation

import RxSwift

public protocol RegisterNewMemberUseCaseProtocol {
    func execute(body: CreateNewMemberRequest) -> Observable<AuthResultEntity>
}

public class RegisterNewMemberUseCase: RegisterNewMemberUseCaseProtocol {
    
    // MARK: - Repositories
    private var oauthRepository: OAuthRepositoryProtocol
    
    // MARK: - Intializer
    public init(oauthRepository: OAuthRepositoryProtocol) {
        self.oauthRepository = oauthRepository
    }
    
    // MARK: - Execute
    public func execute(body: CreateNewMemberRequest) -> Observable<AuthResultEntity> {
        return oauthRepository.registerNewMember(body: body)
    }
}
