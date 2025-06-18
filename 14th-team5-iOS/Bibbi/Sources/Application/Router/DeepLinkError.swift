//
//  DeepLinkError.swift
//  Bibbi
//
//  Created by 마경미 on 25.03.25.
//

enum DeepLinkError: Error {
    case invalidLink
    case notFound
    case errorOccurred
    case invalidNavigation
    
    var message: String {
        switch self {
        case .invalidLink:
            return "잘못된 링크입니다."
        case .notFound:
            return "요청한 페이지를 찾을 수 없습니다."
        case .errorOccurred:
            return "요청 중 에러가 발생했습니다."
        case .invalidNavigation:
            return "현재 페이지를 찾을 수 없습니다."
        }
    }
}
