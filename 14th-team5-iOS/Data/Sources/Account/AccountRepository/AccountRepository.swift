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
    
    func kakaoLogin(with snsType: SNS, vc: UIViewController) -> Observable<APIResult>
    func appleLogin(with snsType: SNS, vc: UIViewController) -> Observable<APIResult>
    func executeNicknameUpdate(memberId: String, parameter: AccountNickNameEditParameter) -> Observable<AccountNickNameEditResponse>
    func signUp(name: String, date: String, photoURL: String?) -> Observable<AccessToken?>
}

public final class AccountRepository: AccountImpl {
    public var disposeBag: DisposeBag = DisposeBag()
    
    private let accessToken: String = "eyJhbGciOiJIUzI1NiIsInR5cGUiOiJhY2Nlc3MiLCJyZWdEYXRlIjoxNzAzODM2OTUzMzkwLCJ0eXAiOiJKV1QifQ.eyJ1c2VySWQiOiIwMUhKQk5YQVYwVFlRMUtFU1dFUjQ1QTJRUCIsImV4cCI6MTcwMzkyMzM1M30.sROYEmc6sxcSY82UKsei95EaDEw0Af8rx6q0qdmValI"
    
    let signInHelper = AccountSignInHelper()
    private let apiWorker = AccountAPIWorker()
    
    private let signInResult = PublishRelay<APIResult>()
    
    public func kakaoLogin(with snsType: SNS, vc: UIViewController) -> Observable<APIResult> {
        return Observable.create { observer in
            self.signInHelper.trySignInWith(sns: snsType, window: vc.view.window)
                .subscribe(onNext: { result in
                    observer.onNext(result)
                    observer.onCompleted()
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    public func appleLogin(with snsType: SNS, vc: UIViewController) -> Observable<APIResult> {
        return Observable.create { observer in
            self.signInHelper.trySignInWith(sns: snsType, window: vc.view.window)
                .subscribe(onNext: { result in
                    observer.onNext(result)
                    observer.onCompleted()
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    public func signUp(name: String, date: String, photoURL: String?) -> Observable<AccessToken?> {
        return Observable.create { observer in
            self.apiWorker.signUpWith(name: name, date: date, photoURL: photoURL)
                .subscribe(
                    onSuccess: { accessToken in
                        observer.onNext(accessToken)
                        observer.onCompleted()
                    },
                    onFailure: { error in
                        observer.onError(error)
                    }
                )
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
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
