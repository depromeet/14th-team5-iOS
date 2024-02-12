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

public final class FamilyManagementDIContainer {
    // MARK: - Properties
    private var globalState: GlobalStateProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    // MARK: - Make
    public func makeViewController() -> FamilyManagementViewController {
        return FamilyManagementViewController(reactor: makeReactor())
    }
    
    public func makeMemberUseCase() -> MemberUseCaseProtocol {
        return MemberUseCase(memberRepository: makeMemberRepository())
    }
    
    public func makeFamilyUseCase() -> FamilyViewUseCaseProtocol {
        return FamilyViewUseCase(familyRepository: makeFamilyRepository())
    }
    
    public func makeMemberRepository() -> MemberRepositoryProtocol {
        return MemberRepository()
    }
    
    public func makeFamilyRepository() -> FamilyRepositoryProtocol {
        return FamilyRepository()
    }
    
    public func makeReactor() -> FamilyManagementViewReactor {
        return FamilyManagementViewReactor(
            memberUseCase: makeMemberUseCase(),
            familyUseCase: makeFamilyUseCase(),
            provider: globalState
        )
    }
}
