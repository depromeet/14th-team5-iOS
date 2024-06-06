//
//  AccountSignInHelperConfig.swift
//  Domain
//
//  Created by geonhui Yu on 12/18/23.
//

import Domain
import Foundation

struct SignInAPIConfig {
    let apple = SignInType.apple.rawValue
    let kakao = SignInType.kakao.rawValue
    
    var helpers: [String: SignInHelperType] {
        [apple: AppleSignInHelper(), kakao: KakaoSignInHelper()]
    }
}
