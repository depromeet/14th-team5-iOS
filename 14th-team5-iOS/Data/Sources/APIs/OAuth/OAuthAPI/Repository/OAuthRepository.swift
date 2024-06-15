//
//  OAuthRepository.swift
//  Data
//
//  Created by 김건우 on 6/6/24.
//

import Core
import Domain

import RxSwift
import RxCocoa

public final class OAuthRepository: OAuthRepositoryProtocol {
    
    // MARK: - Properties
    public var disposeBag = DisposeBag()
    
    public var oAuthApiWorker = OAuthAPIWorker()
    public var tokenKeychainStorage = TokenKeychain()
    
    // MARK: - Intializer
    public init() { }
    
}

extension OAuthRepository {
    
    // MARK: - Refresh Access Token
    
    public func refreshAccessToken(body: RefreshAccessTokenRequest) -> Observable<AuthResultEntity?> {
        let body = RefreshAccessTokenRequestDTO(
            refreshToken: body.refreshToken
        )
        return oAuthApiWorker.refreshAccessToken(body: body)
            .observe(on: RxSchedulers.main)
            .do(onSuccess: { [weak self] in
                guard
                    let keychain = self?.tokenKeychainStorage
                else { return }
                keychain.saveAccessToken($0?.accessToken)
                keychain.saveRefreshToken($0?.refreshToken)
            })
            .asObservable()
    }
    
    
    // MARK: - Register New Member
    
    public func registerNewMember(body: CreateNewMemberRequest) -> Observable<AuthResultEntity?> {
        let body = CreateNewMemberRequestDTO(
            memberName: body.memberName,
            dayOfBirth: body.dayOfBirth,
            profileImageUrl: body.profileImageUrl
        )
        return oAuthApiWorker.registerNewMember(body: body)
            .observe(on: RxSchedulers.main)
            .do(onSuccess: { [weak self] in
                guard
                    let keychain = self?.tokenKeychainStorage
                else { return }
                keychain.saveAccessToken($0?.accessToken)
                keychain.saveRefreshToken($0?.refreshToken)
            })
            .asObservable()
    }
    
    
    // MARK: - Sign In With SNS
    
    public func signIn(_ type: SignInType, body: NativeSocialLoginRequest) -> Observable<AuthResultEntity?> {
        let body = NativeSocialLoginRequestDTO(
            accessToken: body.accessToken
        )
        return oAuthApiWorker.signIn(type, body: body)
            .observe(on: RxSchedulers.main)
            .do(onSuccess: { [weak self] in
                guard
                    let keychain = self?.tokenKeychainStorage
                else { return }
                keychain.saveAccessToken($0?.accessToken)
                keychain.saveRefreshToken($0?.refreshToken)
            })
            .asObservable()
    }
    
    
    // MARK: - Register FCM Token
    
    public func registerNewFCMToken(body: AddFCMTokenRequest) -> Observable<DefaultEntity?> {
        let body = AddFCMTokenRequestDTO(
            fcmToken: body.fcmToken
        )
        return oAuthApiWorker.registerNewFCMToken(body: body)
            .observe(on: RxSchedulers.main)
            .asObservable()
    }
    
    
    // MARK: - Delete FCM Token
    
    public func deleteFCMToken() -> Observable<DefaultEntity?> {
        
        guard
            let fcmToken = tokenKeychainStorage.loadFCMToken()
        else {
            return Observable.just(DefaultEntity(success: false))
        }
        
        return oAuthApiWorker.deleteFCMToken(fcmToken: fcmToken)
            .observe(on: RxSchedulers.main)
            .asObservable()
        
    }
    
}
