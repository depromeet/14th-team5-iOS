//
//  SignInRepository.swift
//  Domain
//
//  Created by 김건우 on 6/7/24.
//

import RxSwift

public protocol SignInRepositoryProtocol {
    func signIn(with type: SignInType, on window: AnyObject?) -> Observable<TokenResultEntity?>
    func signOut() -> Completable
}
