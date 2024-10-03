//
//  BBNetworkError.swift
//  Data
//
//  Created by 김건우 on 10/2/24.
//

import Foundation

// MARK: - Network Error

/// 네트워크 통신 중 발생하는 예외입니다.
public enum BBNetworkError: Error {
    
    /// 받아온 데이터가 없음을 나타냅니다. (204 에러)
    case noContent
    
    /// 잘못된 요청을 보냈음을 나타냅니다. 요청 구문, 유효성 검사 실패 또는 잘못된 파라미터로 인해 서버가 요청을 이해할 수 없을 때 발생합니다. (400 에러)
    case badRequest
    
    /// 인증되지 않은 사용자가 요청을 시도할 때 발생합니다. 일반적으로 로그인이 필요한 API 요청에 사용됩니다. 토큰이 없거나 잘못된 경우에도 발생할 수 있습니다. (401 에러)
    case unauthorized
    
    /// 서버가 요청을 이해했지만 권한이 없어 해당 요청을 수행할 수 없을 때 발생합니다. 사용자는 이 리소스에 액세스할 권한이 없습니다. (403 에러)
    case forbidden
    
    /// 요청한 리소스가 존재하지 않음을 나타냅니다. URL이 잘못되었거나, 리소스가 삭제된 경우 발생합니다. (404 에러)
    case notFound
    
    /// 서버에서 처리 중에 예상치 못한 오류가 발생했음을 의미합니다. 개발자가 서버 측에서 문제를 디버깅해야 합니다. (500 에러)
    case internalServerError
    
    /// 서버가 현재 요청을 처리할 수 없는 상태입니다. 서버가 과부하 상태이거나 유지보수 중일 때 발생할 수 있습니다. (503 에러)
    case serviceUnavailable
    
    /// 이 밖에 알 수 없는 오류가 발생했음을 의미합니다. 상태 코드를 확인해 직접 원인을 파악해야 합니다.
    case error(statusCode: Int)

}


// MARK: - Extensions

extension BBNetworkError {
    
    /// HTTP 상태 코드를 기반으로 BBNetworkError를 반환하는 메서드입니다.
    static func resolve(_ statusCode: Int) -> Self {
        switch statusCode {
        case 204: return .noContent
        case 400: return .badRequest
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 500: return .internalServerError
        case 503: return .serviceUnavailable
        default:  return .error(statusCode: statusCode)
        }
    }
}

extension BBNetworkError: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .noContent: return "No Content"
        case .badRequest: return "Bad Request"
        case .unauthorized: return "Unauthorized"
        case .forbidden: return "Forbidden"
        case .notFound: return "Not Found"
        case .internalServerError: return "Internal Server Error"
        case .serviceUnavailable: return "Service Unavailable"
        case let .error(statusCode): return "Status Code Error: \(statusCode)"
        }
    }
    
}
