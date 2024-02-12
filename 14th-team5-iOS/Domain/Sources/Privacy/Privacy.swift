//
//  Privacy.swift
//  Domain
//
//  Created by Kim dohyun on 12/16/23.
//

import Foundation

import Core

public enum Privacy: String, CaseIterable {
    case version
    case alarm
    case privacy
    case terms
    
    public var descrption: String {
        switch self {
        case .version:
            return "\(Bundle.current.appVersion) 버전"
        case .alarm:
            return "알림 설정"
        case .privacy:
            return "개인정보처리방침"
        case .terms:
            return "이용 약관"
        }
    }
}


public enum UserAuthorization: String, CaseIterable {
    case logout
    case familyResign
    case unAuthorization
    
    public var descrption: String {
        switch self {
        case .logout:
            return "로그 아웃"
        case .familyResign:
            return "가족 탈퇴"
        case .unAuthorization:
            return "회원 탈퇴"
        }
    }
    
}
