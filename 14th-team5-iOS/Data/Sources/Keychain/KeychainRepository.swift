//
//  KeychainRepository.swift
//  Data
//
//  Created by 마경미 on 23.02.24.
//

import Foundation

import Domain

import SwiftKeychainWrapper

final class KeychainRepository: KeychainRepositoryProtocol {
    static let shared = KeychainRepository()
        
    private init() {}
    
    func loadFCMToken() -> String {
        return KeychainWrapper.standard[.fcmToken] ?? ""
    }
    
    func saveFCMToken(token: String) {
        KeychainWrapper.standard[.fcmToken] = token
    }
    
    func removeKeychain() {
        KeychainWrapper.standard.removeAllKeys()
    }
}
