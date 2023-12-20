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
}

public final class AccountRepository: AccountImpl {
    public var disposeBag: DisposeBag = DisposeBag()
    
    let signInHelper = AccountSignInHelper()
    
    public func kakaoLogin(with snsType: SNS, vc: UIViewController) -> Observable<Void> {
        return Observable.just(signInHelper.trySignInWith(sns: snsType, window: vc.view.window))
    }
    public func appleLogin(with snsType: SNS, vc: UIViewController) -> Observable<Void> {
        return Observable.just(signInHelper.trySignInWith(sns: snsType, window: vc.view.window))
    }
    
    public init() {
        signInHelper.bind()
        
        signInHelper.snsSignInResult
            .withUnretained(self)
            .bind(onNext: { _ in print("로그인 완료!!") })
            .disposed(by: disposeBag)
    }
}
