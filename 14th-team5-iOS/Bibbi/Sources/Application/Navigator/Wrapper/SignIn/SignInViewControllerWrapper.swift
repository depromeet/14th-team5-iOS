//
//  SignInViewControllerWrapper.swift
//  App
//
//  Created by 김건우 on 6/26/24.
//

import Core
import Foundation
import MacrosInterface

// TODO: - SignInViewReactor로 이름 수정하기
// TODO: - SignInViewController로 이름 수정하기

@Wrapper<AccountSignInReactor, AccountSignInViewController>
final class SignInViewControllerWrapper {
    
    // MARK: - Make
    
    func makeReactor() -> AccountSignInReactor {
        AccountSignInReactor()
    }
    
}
