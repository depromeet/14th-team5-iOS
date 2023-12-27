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
}

public final class AccountRepository: AccountImpl {
    public var disposeBag: DisposeBag = DisposeBag()
    
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
    
    public init() {
        signInHelper.bind()
    }
}
