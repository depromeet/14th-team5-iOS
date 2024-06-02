//
//  AccountSignInHelperConfig.swift
//  Domain
//
//  Created by geonhui Yu on 12/18/23.
//

import Foundation
import Domain

struct AccountSignInHelperConfig: AccountSignInHelperConfigType {
    let snsHelpers: [String: AccountSignInHelperType] = [
        "APPLE": AppleSignInHelper(),
        "KAKAO": KakaoSignInHelper()
    ]
}
