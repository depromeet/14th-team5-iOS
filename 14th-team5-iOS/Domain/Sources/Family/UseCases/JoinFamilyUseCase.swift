//
//  JoinFamilyUseCase.swift
//  Domain
//
//  Created by 마경미 on 13.01.24.
//

import Foundation

import RxSwift

public protocol JoinFamilyUseCaseProtocol {
    /// joinFamily
    func execute(body: JoinFamilyRequest) -> Single<JoinFamilyData?>
}

public class JoinFamilyUseCase: JoinFamilyUseCaseProtocol {
    private let joinFamilyRepository: JoinFamilyRepository
    
    public init(joinFamilyRepository: JoinFamilyRepository) {
        self.joinFamilyRepository = joinFamilyRepository
    }
    
    public func execute(body: JoinFamilyRequest) -> Single<JoinFamilyData?> {
        return joinFamilyRepository.joinFamily(body: body)
    }
}
