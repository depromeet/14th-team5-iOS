//
//  AccountResignDIContainer.swift
//  App
//
//  Created by Kim dohyun on 1/2/24.
//

import Foundation

import Data
import Domain

final class AccountResignDIContainer {
    typealias ViewController = AccountResignViewCotroller
    typealias Repository = AccountResignInterface
    typealias Reactor = AccountResignViewReactor
    typealias UseCase = AccountResignUseCaseProtocol
        
    public func makeViewController() -> ViewController {
        return AccountResignViewCotroller(reactor: makeReactor())
    }
    public func makeReactor() -> Reactor {
        return AccountResignViewReactor(resignUseCase: makeUseCase())
    }
    
    public func makeRepository() -> Repository {
        return AccountResignViewRepository()
    }
    
    public func makeUseCase() -> UseCase {
        return AccountResignUseCase(accountResignViewRepository: makeRepository())
    }
}
