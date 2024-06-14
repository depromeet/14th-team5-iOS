//
//  SignInRepository.swift
//  Domain
//
//  Created by 김건우 on 6/7/24.
//

import UIKit

import RxSwift

public protocol SignInRepositoryProtocol {
    func signIn(with type: SignInType, on window: AnyObject?) -> Single<TokenResultEntity?>
    func signOut() -> Completable
}
