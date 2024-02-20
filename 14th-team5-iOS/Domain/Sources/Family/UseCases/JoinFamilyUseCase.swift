//
//  JoinFamilyUseCase.swift
//  Domain
//
//  Created by 마경미 on 13.01.24.
//

import Foundation

import RxSwift

@available(*, deprecated, renamed: "FamilyUseCaseProtocol")
public protocol JoinFamilyUseCaseProtocol {
    func execute(body: JoinFamilyRequest) -> Single<JoinFamilyResponse?>
    func resignFamily() -> Single<AccountFamilyResignResponse?>
}

@available(*, deprecated, renamed: "FamilyUseCase")
public class JoinFamilyUseCase: JoinFamilyUseCaseProtocol {
    private let joinFamilyRepository: JoinFamilyRepository
    
    public init(joinFamilyRepository: JoinFamilyRepository) {
        self.joinFamilyRepository = joinFamilyRepository
    }
    
    public func execute(body: JoinFamilyRequest) -> Single<JoinFamilyResponse?> {
        return joinFamilyRepository.joinFamily(body: body)
    }
    
    public func resignFamily() -> Single<AccountFamilyResignResponse?> {
        return joinFamilyRepository.resignFamily()
    }
}
