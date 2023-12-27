//
//  AccountSignUpStrings.swift
//  App
//
//  Created by geonhui Yu on 12/26/23.
//

import Foundation

typealias AccountSignUpStrings = String.AccountSignUp
extension String {
    enum AccountSignUp {
        enum Nickname {
            static var desc: String = "가족에게 주로 불리는 호칭을 입력해주세요"
        }
        enum Date {
            static var desc: String = "가족들이 생일을 챙겨줄 수 있어요"
        }
        enum Profile {
            static var buttonTitle: String = "완료"
        }
    }
}
