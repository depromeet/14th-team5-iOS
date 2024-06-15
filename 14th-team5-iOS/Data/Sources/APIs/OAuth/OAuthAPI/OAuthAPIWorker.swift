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

public typealias OAuthAPIWorker = OAuthAPIs.Worker
extension OAuthAPIs {
    final public class Worker: APIWorker {
        static let queue = {
            ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "OAuthAPIQueue", qos: .utility))
        }()
        
        override init() {
            super.init()
            self.id = "OAuthAPIWorker"
        }
    }
}

// MARK: - Extensions

extension OAuthAPIWorker {
    
    // MARK: - Refresh Access Token
    
    public func refreshAccessToken(body: RefreshAccessTokenRequestDTO) -> Single<AuthResultEntity?> {
        let spec = OAuthAPIs.refreshToken.spec
        
        return request(spec: spec, jsonEncodable: body)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Refresh Token Result: \(str)")
                }
            }
            .map(AuthResultResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    
    // MARK: - Register New Member
    
    public func registerNewMember(body: CreateNewMemberRequestDTO) -> Single<AuthResultEntity?> {
        let spec = OAuthAPIs.registerMember.spec
        
        return request(spec: spec, jsonEncodable: body)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Auth Token Result: \(str)")
                }
            }
            .map(AuthResultResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    
    // MARK: - Sign In With SNS
    
    public func signIn(_ type: SignInType, body: NativeSocialLoginRequestDTO) -> Single<AuthResultEntity?> {
        let spec = OAuthAPIs.signIn(type).spec
        
        return request(spec: spec, jsonEncodable: body)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Auth Token Result: \(str)")
                }
            }
            .map(AuthResultResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    
    
    // MARK: - Register FCM Token
    
    public func registerNewFCMToken(body: AddFCMTokenRequestDTO) -> Single<DefaultEntity?> {
        let spec = OAuthAPIs.registerFCMToken.spec
        
        return request(spec: spec, jsonEncodable: body)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("FCM Register Result: \(str)")
                }
            }
            .map(DefaultResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    
    // MARK: - Delete FCM Token
    
    public func deleteFCMToken(fcmToken token: String) -> Single<DefaultEntity?> {
        let spec = OAuthAPIs.deleteFCMToken(token).spec
        
        return request(spec: spec)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("FCM Delete Result: \(str)")
                }
            }
            .map(DefaultResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    
}
