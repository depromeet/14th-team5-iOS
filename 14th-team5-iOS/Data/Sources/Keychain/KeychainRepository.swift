//
//  KeychainRepository.swift
//  Data
//
//  Created by 마경미 on 23.02.24.
//

import Foundation

import Domain

import SwiftKeychainWrapper

public final class KeychainRepository: KeychainRepositoryProtocol {
    public static let shared = KeychainRepository()
        
    private init() {}
    
    func loadFCMToken() -> String {
        return KeychainWrapper.standard[.fcmToken] ?? ""
    }
    
    func saveFCMToken(token: String) {
        KeychainWrapper.standard[.fcmToken] = token
    }
    
    public func removeKeychain() {
        KeychainWrapper.standard.removeAllKeys()
    }
}
