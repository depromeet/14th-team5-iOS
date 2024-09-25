//
//  BBAPIError.swift
//  BBNetwork
//
//  Created by 김건우 on 9/25/24.
//

import Foundation

/// 통신 중 발생하는 에러입니다.
public enum BBAPIError: Error {
    
    /// 상태 코드입니다. 400~500번 대 상태 코드만 가집니다.
    case statusCode(Int)
    
    /// 디코드 실패 에러입니다.
    case canNotDecode
    
    /// 인코딩 실패 에러입니다.
    case canNotEncode
    
}
