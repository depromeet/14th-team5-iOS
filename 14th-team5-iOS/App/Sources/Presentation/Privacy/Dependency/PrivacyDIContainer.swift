//
//  PrivacyDIContainer.swift
//  App
//
//  Created by Kim dohyun on 12/16/23.
//

import Foundation

import Core
import Data
import Domain


public final class PrivacyDIContainer {
    public typealias ViewContrller = PrivacyViewController
    public typealias Repository = PrivacyViewInterface
    public typealias Reactor = PrivacyViewReactor
    public typealias UseCase = PrivacyViewUseCaseProtocol
    
    public let memberId: String
    
    public init(memberId: String) {
        self.memberId = memberId
    }
    
    
    public func makeViewController() -> PrivacyViewController {
        return PrivacyViewController(reactor: makeReactor())
    }
    
    public func makeRepository() -> Repository {
        return PrivacyViewRepository()
    }
    
    public func makeReactor() -> PrivacyViewReactor {
        return PrivacyViewReactor(privacyUseCase: makeUseCase(), memberId: memberId)
    }
    
    public func makeUseCase() -> PrivacyViewUseCase {
        return PrivacyViewUseCase(privacyViewRepository: makeRepository())
    }
    
}
