//
//  BBAPIConfiguration.swift
//  BBNetwork
//
//  Created by 김건우 on 9/25/24.
//

import Foundation

import Alamofire

/// BBAPI의 설정값입니다.
public struct BBAPIConfiguration {
    
    /// 기초 URL을 반환합니다. 빌드 환경에 따라 반환되는 URL이 달라집니다.
    public static var baseUrl: String = {
        #if PRD
        return "https://api.no5ing.kr/v1"
        #else
        return "https://dev.api.no5ing.kr/v1"
        #endif
    }()
    
}
