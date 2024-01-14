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

public final class FamilyManagementDIContainer: BaseDIContainer {
    public typealias ViewController = FamilyManagementViewController
    public typealias UseCase = FamilyViewUseCaseProtocol
    public typealias Repository = FamilyRepositoryProtocol
    public typealias Reactor = FamilyManagementViewReactor
    
    private var globalState: GlobalStateProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    public func makeViewController() -> ViewController {
        return FamilyManagementViewController(reactor: makeReactor())
    }
    
    public func makeUsecase() -> UseCase {
        return FamilyViewUseCase(familyRepository: makeRepository())
    }
    
    public func makeRepository() -> FamilyRepositoryProtocol {
        return FamilyRepository()
    }
    
    public func makeReactor() -> FamilyManagementViewReactor {
        return FamilyManagementViewReactor(familyUseCase: makeUsecase(), provider: globalState)
    }
}
