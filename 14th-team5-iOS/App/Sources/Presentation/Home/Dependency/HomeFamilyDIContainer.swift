//
//  HomeFamilyDIContainer.swift
//  App
//
//  Created by 마경미 on 14.01.24.
//

import Foundation

import Domain
import Data

final class HomeFamilyDIContainer {
    func makeViewController() -> HomeFamilyViewController {
        return HomeFamilyViewController(reactor: makeReactor())
    }
    
    public func makeFamilyRepository() -> SearchFamilyRepository {
        return FamilyAPIs.Worker()
    }
    
    public func makeInviteFamilyRepository() -> FamilyRepositoryProtocol {
        return FamilyRepository()
    }
    
    func makeFamilyUseCase() -> SearchFamilyMemberUseCaseProtocol {
        return SearchFamilyUseCase(searchFamilyRepository: makeFamilyRepository())
    }
    
    func makeInviteFamilyUseCase() -> FamilyViewUseCaseProtocol {
        return FamilyViewUseCase(familyRepository: makeInviteFamilyRepository())
    }
    
    public func makeReactor() -> HomeFamilyViewReactor {
        return HomeFamilyViewReactor(searchFamilyUseCase: makeFamilyUseCase(), inviteFamilyUseCase: makeInviteFamilyUseCase())
    }
    
}
