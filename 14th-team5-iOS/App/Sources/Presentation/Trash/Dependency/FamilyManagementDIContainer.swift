//
//  LinkShareDIContainer.swift
//  App
//
//  Created by 김건우 on 12/16/23.
//

import UIKit

import Core
import Data
import Domain

@available(*, deprecated, renamed: "ManagementViewControllerWrapper")
public final class FamilyManagementDIContainer {

    // MARK: - Make
    public func makeViewController() -> ManagementViewController {
        return ManagementViewController(reactor: makeReactor())
    }
    
    public func makeMemberUseCase() -> MemberUseCaseProtocol {
        return MemberUseCase(memberRepository: makeMemberRepository())
    }
    
    public func makeFamilyUseCase() -> FamilyUseCaseProtocol {
        return FamilyUseCase(familyRepository: makeFamilyRepository())
    }
    
    public func makeMemberRepository() -> MemberRepositoryProtocol {
        return MemberRepository()
    }
    
    public func makeFamilyRepository() -> FamilyRepositoryProtocol {
        return FamilyRepository()
    }
    
    public func makeReactor() -> ManagementReactor {
        return ManagementReactor()
    }
}
