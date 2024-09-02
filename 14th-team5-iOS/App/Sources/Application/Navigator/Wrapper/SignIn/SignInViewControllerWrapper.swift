//
//  SignInViewControllerWrapper.swift
//  App
//
//  Created by 김건우 on 6/26/24.
//

import Core
import Foundation

// TODO: - SignInViewReactor로 이름 수정하기
// TODO: - SignInViewController로 이름 수정하기
final class SignInViewControllerWrapper: BaseWrapper {
    
    // MARK: - Typealias
    
    typealias R = AccountSignInReactor
    typealias V = AccountSignInViewController
    
    // MARK: - Properties
    
    var reactor: AccountSignInReactor {
        makeReactor()
    }
    
    var viewController: AccountSignInViewController {
        makeViewController()
    }
    
    // MARK: - Make
    
    func makeReactor() -> AccountSignInReactor {
        AccountSignInReactor()
    }
    
    func makeViewController() -> AccountSignInViewController {
        AccountSignInViewController(reactor: makeReactor())
    }
    
}
