//
//  InputFamilyLinkDIContainer.swift
//  App
//
//  Created by 마경미 on 13.01.24.
//

import UIKit

import Core
import Data
import Domain

@available(*, deprecated, renamed: "InputFamilyLinkControllerWrapper")
final class InputFamilyLinkDIContainer {
    public func makeViewController() -> InputFamilyLinkViewController {
        return InputFamilyLinkViewController(reactor: makeReactor())
    }
    
    public func makeUseCase() -> FamilyUseCaseProtocol {
        return FamilyUseCase(familyRepository: makeRepository())
    }
    
    public func makeRepository() -> FamilyRepositoryProtocol {
        return FamilyRepository()
    }
    
    public func makeReactor() -> InputFamilyLinkReactor {
        return InputFamilyLinkReactor()
    }
}

