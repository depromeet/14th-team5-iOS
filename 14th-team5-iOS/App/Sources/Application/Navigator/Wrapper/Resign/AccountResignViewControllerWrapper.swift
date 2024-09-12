//
//  AccountResignViewControllerWrapper.swift
//  App
//
//  Created by Kim dohyun on 9/12/24.
//

import Core
import Foundation

final class AccountResignViewControllerWrapper: BaseWrapper {
    
    typealias R = AccountResignViewReactor
    typealias V = AccountResignViewCotroller
    
    
    var reactor: AccountResignViewReactor {
        return makeReactor()
    }
    
    var viewController: AccountResignViewCotroller {
        return makeViewController()
    }
    
    func makeViewController() -> AccountResignViewCotroller {
        return AccountResignViewCotroller(reactor: makeReactor())
    }
    
    func makeReactor() -> AccountResignViewReactor {
        return AccountResignViewReactor()
    }
}
