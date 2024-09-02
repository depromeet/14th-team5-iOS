//
//  UserDefaultsType.swift
//  Core
//
//  Created by 김건우 on 6/2/24.
//

import Foundation

public protocol UserDefaultsType {
    var userDefaults: UserDefaultsWrapper { get }
    func remove(forKey key: UserDefaultsWrapper.Key)
}

extension UserDefaultsType {
    public var userDefaults: UserDefaultsWrapper {
        UserDefaultsWrapper.standard
    }
    
    public func remove(forKey key: UserDefaultsWrapper.Key) {
        UserDefaultsWrapper.standard.remove(forKey: key)
    }
}
