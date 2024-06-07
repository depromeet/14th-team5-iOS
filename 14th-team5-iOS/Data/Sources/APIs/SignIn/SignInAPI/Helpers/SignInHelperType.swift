//
//  SignInHelperType.swift
//  Data
//
//  Created by 김건우 on 6/7/24.
//

import UIKit
import Domain

import RxSwift

protocol SignInHelperType {
    func signIn(on window: UIWindow?) -> Single<TokenResultEntity?>
    func signOut() -> Completable
}
