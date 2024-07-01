//
//  App.swift
//  Core
//
//  Created by geonhui Yu on 12/14/23.
//

import Foundation

@available(*, deprecated, message: "KeyChainWrapper 혹은 UserDefaultsWrpper 사용")
public enum App {
    
    public static let indicator = BibbiLoadIndicator()
    
    public enum Repository {
        public static let token = TokenRepository()
        public static let member = MemberRepository()
        public static let deepLink = DeepLinkRepository()
    }
}
