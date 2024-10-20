//
//  TokenRepository.swift
//  Core
//
//  Created by geonhui Yu on 12/14/23.
//

import Foundation

import RxCocoa
import RxSwift

@available(*, deprecated, renamed: "AuthToken")
public struct AccessToken: Codable, Equatable {
    public var accessToken: String?
    public var refreshToken: String?
    public var isTemporaryToken: Bool?
    
    public init(accessToken: String?, refreshToken: String?, isTemporaryToken: Bool?) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.isTemporaryToken = isTemporaryToken
    }
}

@available(*, deprecated, renamed: "TokenKeychain")
public class TokenRepository: RxObject {
    public lazy var keychain = KeychainWrapper(serviceName: "Bibbi", accessGroup: "P9P4WJ623F.com.5ing.bibbi")
    
    public let accessToken = BehaviorRelay<AccessToken?>(value: (KeychainWrapper.standard[.accessToken] as String?)?.decode(AccessToken.self))
    
    public func clearAccessToken() {
        KeychainWrapper.standard.remove(forKey: .accessToken)
        accessToken.accept(nil)
    }
    
    override public func bind() {
        super.bind()
        accessToken
            .distinctUntilChanged()
            .subscribe(on: RxSchedulers.io)
            .withUnretained(self)
            .subscribe {
                guard let jsonData = try? JSONEncoder().encode($0.1),
                      let jsonStr = String(data: jsonData, encoding: .utf8) else {
                    KeychainWrapper.standard.remove(forKey: .accessToken)
                    return
                }
                
                if let jsonData = jsonStr.data(using: .utf8),
                   let decodedUser = try? JSONDecoder().decode(AccessToken.self, from: jsonData) {
                    self.keychain.set(decodedUser.accessToken ?? "fail", forKey: "accessToken")
                } else {
                    print("Failed to decode jsonStr or jsonStr is nil")
                }
                
                KeychainWrapper.standard[.accessToken] = jsonStr
            }
            .disposed(by: disposeBag)
    }
    
    override public func unbind() {
        super.unbind()
    }
}
