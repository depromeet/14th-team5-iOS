//
//  OAuthRepository.swift
//  Domain
//
//  Created by 김건우 on 6/6/24.
//

import Foundation

import RxSwift

public protocol OAuthRepositoryProtocol {
    var disposeBag: DisposeBag { get }
    
    func refreshAccessToken(body: RefreshAccessTokenRequest) -> Observable<AuthResultEntity?>
    func registerNewMember(body: CreateNewMemberRequest) -> Observable<AuthResultEntity?>
    func signIn(_ type: SignInType, body: NativeSocialLoginRequest) -> Observable<AuthResultEntity?>
    func registerNewFCMToken(body: AddFCMTokenRequest) -> Observable<DefaultResponseEntity?>
    func deleteFCMToken(fcmToken token: String) -> Observable<DefaultResponseEntity?>
}
