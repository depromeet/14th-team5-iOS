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
    func executePresignedImageURLCreate(parameter: CameraDisplayImageParameters) -> Observable<CameraDisplayImageResponse?>
    func executeProfileImageUpload(to url: String, data: Data) -> Observable<Bool>
}

public final class AccountRepository: AccountImpl {
    public var disposeBag: DisposeBag = DisposeBag()
    
    private let accessToken: String = App.Repository.token.accessToken.value?.accessToken ?? ""
    
    let signInHelper = AccountSignInHelper()
    private let apiWorker = AccountAPIWorker()
    private let profileWorker = ProfileAPIWorker()
    private let meApiWorekr = MeAPIWorker()
    
    private let fetchMemberInfo = PublishRelay<Void>()
    private let signUpFinished = PublishRelay<Void>()
    
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
    
    // MARK: 회원가입 이후 멤버 조회
    private func fetchMember() {
        meApiWorekr.fetchMemberInfo()
            .asObservable()
            .withUnretained(self)
            .bind(onNext: {
                let memberInfo = $0.1
                print("member Info: \(memberInfo?.memberId)")
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: 링크가입 사용자 -> 가입 이후 가족가입
    private func joinFamily(inviteCode: String?) {
        guard let inviteCode else { return }
        
        print("inviteCode: \(inviteCode)")
        
        meApiWorekr.joinFamily(with: inviteCode)
            .asObservable()
            .withUnretained(self)
            .bind(onNext: { App.Repository.member.familyId.accept($0.1?.familyId) })
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
                        
                        self.fetchMemberInfo.accept(())
                        self.signUpFinished.accept(())
                        
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
    
    public func executePresignedImageURLCreate(parameter: CameraDisplayImageParameters) -> Observable<CameraDisplayImageResponse?> {
        return profileWorker.createProfileImagePresingedURL(accessToken: accessToken, parameters: parameter)
            .compactMap { $0?.toDomain() }
            .asObservable()
    }
    
    public func executeProfileImageUpload(to url: String, data: Data) -> Observable<Bool> {
        return profileWorker.uploadToProfilePresingedURL(accessToken: accessToken, toURL: url, with: data)
            .asObservable()
    }
    
    
    public init() {
        signInHelper.bind()
        
        fetchMemberInfo
            .withUnretained(self)
            .bind(onNext: { $0.0.fetchMember() })
            .disposed(by: disposeBag)
        
        signUpFinished
            .withUnretained(self)
            .bind(onNext: { $0.0.joinFamily(inviteCode: UserDefaults.standard.inviteCode) })
            .disposed(by: disposeBag)
    }
}
