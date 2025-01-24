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
            static let title: String = "닉네임을 입력해주세요"
            static let placeholder: String = "김아빠"
            static let errorMsg: String = "9자 이내로 입력해주세요"
            static var desc: String = "가족에게 주로 불리는 호칭을 입력해주세요"
        }
        enum Date {
            static let title: String = "안녕하세요 %@님, 생일이 언제신가요?"
            static let desc: String = "가족들이 생일을 챙겨줄 수 있어요"
            
            static let year: String = "년"
            static let yearPlaceholder: String = "0000"
            static let month: String = "월"
            static let monthPlaceholder: String = "00"
            static let day: String = "일"
            static let dayPlaceholder: String = "00"
            
            static let errorMsg: String = "올바른 날짜를 입력해주세요"
        }
        enum Profile {
            static let title: String = "마지막이에요. %@님의\n프로필을 선택해보세요"
            static var buttonTitle: String = "완료"
        }
    }
}
