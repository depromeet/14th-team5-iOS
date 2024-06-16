//
//  SignInAPIConfig.swift
//  Data
//
//  Created by 김건우 on 6/7/24.
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
