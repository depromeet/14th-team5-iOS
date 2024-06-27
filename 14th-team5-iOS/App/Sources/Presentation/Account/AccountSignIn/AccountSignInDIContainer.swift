//
//  AccountSignInDIContainer.swift
//  App
//
//  Created by geonhui Yu on 12/19/23.
//

import Foundation

import Data
import Domain
import Core

@available(*, deprecated, renamed: "SignInViewControllerWrapper")
public final class AccountSignInDIContainer: BaseDIContainer {
    public typealias ViewContrller = AccountSignInViewController
    public typealias Repository = AccountImpl
    public typealias Reactor = AccountSignInReactor
    
    public func makeViewController() -> ViewContrller {
        return AccountSignInViewController(reactor: makeReactor())
    }
    public func makeRepository() -> Repository {
        return AccountRepository()
    }
    public func makeReactor() -> Reactor {
        return AccountSignInReactor(/*accountRepository: AccountRepository(), fcmUseCase: makeFCMUseCase()*/)
    }
}

extension AccountSignInDIContainer {
    private func makeFCMRepository() -> FCMRepositoryProtocol {
        return MeAPIs.Worker()
    }
    
    private func makeFCMUseCase() -> FCMUseCaseProtocol {
        return FCMUseCase(FCMRepository: makeFCMRepository())
    }
}
