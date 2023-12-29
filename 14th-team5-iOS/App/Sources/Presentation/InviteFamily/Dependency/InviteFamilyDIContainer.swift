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

public final class InviteFamilyDIContainer: BaseDIContainer {
    public typealias ViewController = InviteFamilyViewController
    public typealias UseCase = InviteFamilyViewUseCaseProtocol
    public typealias Repository = FamilyRepositoryProtocol
    public typealias Reactor = InviteFamilyViewReactor
    
    private var globalState: GlobalStateProviderType {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    public func makeViewController() -> InviteFamilyViewController {
        return InviteFamilyViewController(reacter: makeReactor())
    }
    
    public func makeUsecase() -> InviteFamilyViewUseCaseProtocol {
        return InviteFamilyViewUseCase(familyRepository: makeRepository())
    }
    
    public func makeRepository() -> FamilyRepositoryProtocol {
        return FamilyRepository()
    }
    
    public func makeReactor() -> InviteFamilyViewReactor {
        return InviteFamilyViewReactor(makeUsecase(), provider: globalState)
    }
}
