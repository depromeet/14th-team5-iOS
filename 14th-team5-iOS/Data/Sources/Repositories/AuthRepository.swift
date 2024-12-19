//
//  OAuthRepository.swift
//  Data
//
//  Created by 김건우 on 6/6/24.
//

import Core
import Domain
import Foundation

import RxSwift
import RxCocoa

public final class AuthRepository: OAuthRepositoryProtocol {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    
    private let meAPIWorker = MeeAPIWorker()
    private let authAPIWorker = AuthAPIWorker()
    private let tokenKeychainStorage = TokenKeychain()
    
    // MARK: - Intializer
    public init() { }
}

extension AuthRepository {
    
    // MARK: - Refresh Access Token
    
    public func refreshAccessToken(
        body: RefreshAccessTokenRequest
    ) -> Observable<AuthResultEntity> {
        let requestBody = RefreshTokenRequestDTO(
            refreshToken: body.refreshToken
        )

        return authAPIWorker.refreshAccessToken(body: requestBody)
            .flatMap { [weak self] response -> Observable<AuthResultEntity> in
                guard let self = self else {
                    return Observable.error(NSError(domain: "RefreshError", code: -1, userInfo: nil))
                }
                
                let accessToken = AuthToken(
                    accessToken: response.accessToken,
                    refreshToken: response.refreshToken,
                    isTemporaryToken: response.isTemporaryToken
                )
                
                self.tokenKeychainStorage.saveAuthToken(accessToken)
                return Observable.just(response.toDomain())
            }
    }
    
    
    // MARK: - Register New Member
    
    public func registerNewMember(
        body: CreateNewMemberRequest
    ) -> Observable<AuthResultEntity> {
        let body = SignUpRequestDTO(
            memberName: body.memberName,
            dayOfBirth: body.dayOfBirth,
            profileImageUrl: body.profileImageUrl
        )
        
        return authAPIWorker.registerNewMember(body: body)
            .flatMap { [weak self] response -> Observable<AuthResultEntity> in
                guard let keychain = self?.tokenKeychainStorage else {
                    return Observable.error(NSError(domain: "RegisterError", code: -1, userInfo: nil))
                }
                let accessToken = AuthToken(
                    accessToken: response.accessToken,
                    refreshToken: response.refreshToken,
                    isTemporaryToken: response.isTemporaryToken
                )
                keychain.saveAuthToken(accessToken)
                
                return Observable.just(response.toDomain())
            }
    }
    
    
    // MARK: - Sign In With SNS
    
    public func signIn(
        _ type: SignInType,
        body: NativeSocialLoginRequest
    ) -> Observable<AuthResultEntity> {
        let body = NativeSocialLoginRequestDTO(
            accessToken: body.accessToken
        )
        return authAPIWorker.signIn(type, body: body)
            .flatMap { [weak self] response -> Observable<AuthResultEntity> in
                guard let keychain = self?.tokenKeychainStorage else {
                    return Observable.error(NSError(domain: "SignInError", code: -1, userInfo: nil))
                }
                let accessToken = AuthToken(
                    accessToken: response.accessToken,
                    refreshToken: response.refreshToken,
                    isTemporaryToken: response.isTemporaryToken
                )
                keychain.saveAuthToken(accessToken)
                
                return Observable.just(response.toDomain())
            }
    }
    
    
    // MARK: - Register FCM Token
    public func registerNewFCMToken(
        body: AddFCMTokenRequest
    ) -> Observable<DefaultEntity> {
        let body = AddFCMTokenRequestDTO(
            fcmToken: body.fcmToken
        )
        
        return meAPIWorker.registerNewFCMToken(body: body)
            .map { $0.toDomain() }
    }
    
    
    public func deleteFCMToken() -> Observable<DefaultEntity> {
        
        guard
            let fcmToken = tokenKeychainStorage.loadFCMToken()
        else {
            return Observable.just(DefaultEntity(success: false))
        }
        
        return meAPIWorker.deleteFCMToken(fcmToken: fcmToken)
            .map { $0.toDomain() }
    }
}
