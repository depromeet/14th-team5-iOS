//
//  AccountRepository.swift
//  Data
//
//  Created by geonhui Yu on 12/18/23.
//

import UIKit

import Core
import Domain

import ReactorKit
import RxCocoa
import RxSwift

public enum AccountLoaction {
    case profile
    case account
}

public protocol AccountImpl: AnyObject {
    var disposeBag: DisposeBag { get }
    
    func kakaoLogin(with snsType: SNS, vc: UIViewController) -> Observable<APIResult>
    func appleLogin(with snsType: SNS, vc: UIViewController) -> Observable<APIResult>
    func executeNicknameUpdate(memberId: String, parameter: AccountNickNameEditParameter) -> Observable<AccountNickNameEditResponse>
    func signUp(name: String, date: String, photoURL: String?) -> Observable<AccessTokenResponse?>
}

public final class AccountRepository: AccountImpl {
    public var disposeBag: DisposeBag = DisposeBag()
    
    private let accessToken: String = "eyJyZWdEYXRlIjoxNzA0MTE4NDIzMzc5LCJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsInR5cGUiOiJhY2Nlc3MifQ.eyJ1c2VySWQiOiIwMUhKQk5YQVYwVFlRMUtFU1dFUjQ1QTJRUCIsImV4cCI6MTcwNDIwNDgyM30.pjas-Dx3zYwU1LsrW-FoJl12tr3hZ8DLI7gCX28DePE"
    
    let signInHelper = AccountSignInHelper()
    private let apiWorker = AccountAPIWorker()
    
    private let signInResult = PublishRelay<APIResult>()
    
    public func kakaoLogin(with snsType: SNS, vc: UIViewController) -> Observable<APIResult> {
        return Observable.create { observer in
            self.signInHelper.trySignInWith(sns: snsType, window: vc.view.window)
                .subscribe(onNext: { result in
                    observer.onNext(result)
                    observer.onCompleted()
                }, onError: { error in
                    print("error: \(error.localizedDescription)")
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
                }, onError: { error in
                    print("error: \(error.localizedDescription)")
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func fetchMember() {
        let myApiWorker = MeAPIWorker()
        myApiWorker.fetchMemberInfo()
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
            })
            .disposed(by: disposeBag)
    }
    
    public func signUp(name: String, date: String, photoURL: String?) -> Observable<AccessTokenResponse?> {
        return Observable.create { observer in
            self.apiWorker.signUpWith(name: name, date: date, photoURL: photoURL)
                .subscribe(
                    onSuccess: { token in
                        guard let token = token else { return }
                        let tk = AccessToken(accessToken: token.accessToken, refreshToken: token.refreshToken, isTemporaryToken: token.isTemporaryToken)
                        App.Repository.token.accessToken.accept(tk)
                        
                        self.fetchMember()
                        
                        observer.onNext(token)
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
