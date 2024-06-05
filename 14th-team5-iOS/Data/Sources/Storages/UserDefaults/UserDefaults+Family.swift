//
//  File.swift
//  Data
//
//  Created by 김건우 on 6/2/24.
//

import Core
import Foundation


// NOTE: - 예시 코드

public protocol MemberUserDefaultsType: UserDefaultsType {
    func save(_ memberId: String)
    func loadMemberId() -> String?
}


final public class MemberUserDefaults: MemberUserDefaultsType {
 
    // MARK: - Intializer
    public init() { }
    
    
    // MARK: - Member Id
    
    public func save(_ memberId: String) {
        userDefaults[.memberId] = memberId
    }
    
    public func loadMemberId() -> String? {
        guard
            let value: String = userDefaults[.memberId]
        else { return nil }
        return value
    }
    
    // ...
    
}
