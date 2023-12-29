//
//  AccountSignUpDIContainer.swift
//  App
//
//  Created by geonhui Yu on 12/24/23.
//

import Foundation

import Data
import Core

public final class AccountSignUpDIContainer: BaseDIContainer {
        
    public typealias ViewContrller = AccountSignUpViewController
    public typealias Repository = AccountImpl
    public typealias Reactor = AccountSignUpReactor
    public typealias NickNameViewController = AccountNicknameViewController
    private let memberId: String
    
    public init(memberId: String = "") {
        self.memberId = memberId
    }
    
    public func makeViewController() -> AccountSignUpViewController {
        return AccountSignUpViewController(reacter: makeReactor())
    }
    
    public func makeRepository() -> Repository {
        return AccountRepository()
    }
    
    public func makeReactor() -> Reactor {
        return AccountSignUpReactor(accountRepository: AccountRepository(), memberId: memberId)
    }
    
    
    public func makeNickNameViewController() -> NickNameViewController {
        return AccountNicknameViewController(reacter: makeReactor())
    }
}
