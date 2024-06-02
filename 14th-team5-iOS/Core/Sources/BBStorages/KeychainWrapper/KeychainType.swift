//
//  KeychainType.swift
//  Core
//
//  Created by 김건우 on 6/2/24.
//

import Foundation

public protocol KeychainType {
    var keychain: KeychainWrapper { get }
}

extension KeychainType {
    public var keychain: KeychainWrapper {
        KeychainWrapper.standard
    }
}
