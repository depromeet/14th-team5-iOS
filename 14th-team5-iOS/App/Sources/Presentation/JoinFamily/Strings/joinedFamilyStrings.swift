//
//  joinedFamilyStrings.swift
//  App
//
//  Created by geonhui Yu on 2/8/24.
//

import Foundation

typealias JoinedFamilyStrings = String.JoinedFamily
extension String {
    enum JoinedFamily {}
}

extension JoinedFamilyStrings {
    static let title: String = "이미 가입된 가족이 있어요."
    static let caption: String = "하나의 가족에만 소속될 수 있어요."
    static let homeBtnTitle: String = "홈으로 돌아가기"
    static let joinFamilyBtnTitle: String = "가족탈퇴 후 초대링크로 입장하기"
}
