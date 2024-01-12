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
    func execute(body: JoinFamilyRequest) -> Single<Void?>
}

public class JoinFamilyUseCase: JoinFamilyUseCaseProtocol {
    private let joinFamilyRepository: JoinFamilyRepository
    
    public init(joinFamilyRepository: JoinFamilyRepository) {
        self.joinFamilyRepository = joinFamilyRepository
    }
    
    public func execute(body: JoinFamilyRequest) -> Single<Void?> {
        return joinFamilyRepository.joinFamily(body: body)
    }
}
