//
//  SignInHelperType.swift
//  Data
//
//  Created by 김건우 on 6/7/24.
//

import Domain

import RxSwift

protocol SignInHelperType {
    func signIn(on window: AnyObject?) -> Single<TokenResultEntity?>
    func signOut() -> Completable
}
