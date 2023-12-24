//
//  OnBoardingDIContainer.swift
//  App
//
//  Created by geonhui Yu on 12/25/23.
//

import Foundation

import Data
import Core

public final class OnBoardingDIContainer: BaseDIContainer {
    
    public typealias ViewContrller = OnBoardingViewController
    public typealias Repository = AccountImpl
    public typealias Reactor = OnBoardingReactor
    
    public func makeViewController() -> ViewContrller {
        return OnBoardingViewController(reacter: makeReactor())
    }
    public func makeRepository() -> Repository {
        return AccountRepository()
    }
    public func makeReactor() -> Reactor {
        return OnBoardingReactor(accountRepository: AccountRepository())
    }
}
