//
//  OAuthRepository.swift
//  Domain
//
//  Created by 김건우 on 6/6/24.
//

import Foundation

import RxSwift

public protocol OAuthRepositoryProtocol {
    func refreshAccessToken(body: RefreshAccessTokenRequest) -> Observable<AuthResultEntity>
    func registerNewMember(body: CreateNewMemberRequest) -> Observable<AuthResultEntity>
    func signIn(_ type: SignInType, body: NativeSocialLoginRequest) -> Observable<AuthResultEntity>
    func registerNewFCMToken(body: AddFCMTokenRequest) -> Observable<DefaultEntity>
    func deleteFCMToken() -> Observable<DefaultEntity>
}
