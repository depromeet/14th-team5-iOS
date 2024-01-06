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
    private let accountType: AccountLoaction
    
    public init(memberId: String = "", accountType: AccountLoaction = .account) {
        self.memberId = memberId
        self.accountType = accountType
    }
    
    public func makeViewController() -> AccountSignUpViewController {
        return AccountSignUpViewController(reacter: makeReactor())
    }
    
    public func makeRepository() -> Repository {
        return AccountRepository()
    }
    
    public func makeReactor() -> Reactor {
        return AccountSignUpReactor(accountRepository: AccountRepository(), memberId: memberId, profileType: accountType)
    }
    
    
    public func makeNickNameViewController() -> NickNameViewController {
        return AccountNicknameViewController(reactor: makeReactor())
    }
}
