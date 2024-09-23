//
//  AccountResignViewControllerWrapper.swift
//  App
//
//  Created by Kim dohyun on 9/12/24.
//

import Core
import Foundation
import MacrosInterface

@Wrapper<AccountResignViewReactor, AccountResignViewCotroller>
final class AccountResignViewControllerWrapper {
    
    func makeReactor() -> AccountResignViewReactor {
        return AccountResignViewReactor()
    }
}
