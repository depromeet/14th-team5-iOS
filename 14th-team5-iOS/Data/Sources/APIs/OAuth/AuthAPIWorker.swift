//
//  OAuthAPIWorker.swift
//  Data
//
//  Created by 김건우 on 6/6/24.
//

import Core
import Domain
import Foundation

import RxSwift

typealias AuthAPIWorker = AuthAPIs.Worker
extension AuthAPIWorker {
    /// 리프레시 토큰으로 새로운 토큰을 발급받는 Method입니다.
    /// HTTP Method: POST
    /// - Parameters: body: RefreshAcceessTokenRequestDTO
    /// - Returns: AuthResultResponseDTO
    func refreshAccessToken(body: RefreshTokenRequestDTO) -> Observable<RefreshTokenResponseDTO> {
        let spec = AuthAPIs.refreshToken.spec
        return request(spec)
    }
    
    /// 회원가입을 위한 Method입니다
    /// HTTP Method: POST
    /// - Parameters: body: SignUpRequestDTO
    /// - Returns: SignUpResponseDTO
    func registerNewMember(body: SignUpRequestDTO) -> Observable<SignUpResponseDTO> {
        let spec = AuthAPIs.registerMember.spec
        
        // TODO: 헤더 테스트 해보기
        return request(spec)
    }
    
    
    /// apple, kakao등 소셜 로그인 Method입니다.
    /// HTTP Method: POST
    /// - Parameters: type: SignInType, body: NativeSocialLoginRequestDTO
    /// - Returns: NativeSocialLoginResponseDTO
    func signIn(_ type: SignInType, body: NativeSocialLoginRequestDTO) -> Observable<NativeSocialLoginResponseDTO> {
        let spec = AuthAPIs.signIn(type).spec
        
        // TODO: 헤더 테스트 해보기
        return request(spec)
    }
}
