//
//  AccountRepository.swift
//  Data
//
//  Created by geonhui Yu on 12/18/23.
//

import UIKit
import Domain

import ReactorKit
import RxCocoa
import RxSwift

public protocol AccountImpl: AnyObject {
    var disposeBag: DisposeBag { get }
    
    func kakaoLogin(with snsType: SNS, vc: UIViewController) -> Observable<Void>
    func appleLogin(with snsType: SNS, vc: UIViewController) -> Observable<Void>
    func signUp(name: String, date: String, photoURL: String?) -> Observable<Void>
    func executeNicknameUpdate(memberId: String, parameter: AccountNickNameEditParameter) -> Observable<AccountNickNameEditResponse>
}

public final class AccountRepository: AccountImpl {
    public var disposeBag: DisposeBag = DisposeBag()
    
    private let accessToken: String = "eyJhbGciOiJIUzI1NiIsInR5cGUiOiJhY2Nlc3MiLCJyZWdEYXRlIjoxNzAzODM2OTUzMzkwLCJ0eXAiOiJKV1QifQ.eyJ1c2VySWQiOiIwMUhKQk5YQVYwVFlRMUtFU1dFUjQ1QTJRUCIsImV4cCI6MTcwMzkyMzM1M30.sROYEmc6sxcSY82UKsei95EaDEw0Af8rx6q0qdmValI"
    
    let signInHelper = AccountSignInHelper()
    private let apiWorker = AccountAPIWorker()
    
    public func kakaoLogin(with snsType: SNS, vc: UIViewController) -> Observable<Void> {
        return Observable.just(signInHelper.trySignInWith(sns: snsType, window: vc.view.window))
    }
    public func appleLogin(with snsType: SNS, vc: UIViewController) -> Observable<Void> {
        return Observable.just(signInHelper.trySignInWith(sns: snsType, window: vc.view.window))
    }
    public func signUp(name: String, date: String, photoURL: String?) -> Observable<Void> {
        return apiWorker.signUpWith(name: name, date: date, photoURL: photoURL)
            .asObservable()
            .map { _ in }
    }
    
    public func executeNicknameUpdate(memberId: String, parameter: AccountNickNameEditParameter) -> Observable<AccountNickNameEditResponse> {
        return apiWorker.updateProfileNickName(accessToken: accessToken, memberId: memberId, parameter: parameter)
            .compactMap { $0?.toDomain() }
            .asObservable()
    }
    
    public init() {
        signInHelper.bind()
    }
}
