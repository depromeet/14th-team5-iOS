//
//  Privacy.swift
//  Domain
//
//  Created by Kim dohyun on 12/16/23.
//

import Foundation


public enum Privacy: String, CaseIterable {
    case version = "버전 정보"
    case alarm = "알림 설정"
    case terms = "약관 및 정책"
}


public enum UserAuthorization: String, CaseIterable {
    case logout = "로그 아웃"
    case unAuthorization = "회원 탈퇴"
}
