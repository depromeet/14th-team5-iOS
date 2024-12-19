//
//  BBNetworkErrorLogger.swift
//  Core
//
//  Created by 김건우 on 10/5/24.
//

import Foundation

// MARK: - Error

/// 네트워크 통신 중 발생하는 예외입니다.
public enum BBNetworkError: Error {
    
    /// 네트워크에 연결할 수 없음을 의미합니다. (오프라인 상태)
    case notConnected
    
    /// 사용자 또는 시스템에 의해 통신이 취소되었음을 의미합니다.
    case cancelled
    
    /// 요청 시간이 초과되었음을 의미합니다.
    case timeout
    
    /// 잘못된 요청을 보냈음을 의미합니다. (상태 코드 400)
    case badRequest
    
    /// 인증되지 않은 요청임을 의미합니다. (상태 코드 401)
    case unauthorized
    
    /// 접근이 금지되었음을 의미합니다. (상태 코드 403)
    case forbidden
    
    /// 요청한 리소스를 찾을 수 없음을 의미합니다. (상태 코드 404)
    case notFound
    
    /// 허용되지 않은 메소드 요청을 의미합니다. (상태 코드 405)
    case methodNotAllowed
    
    /// 요청이 갈등을 일으켰음을 의미합니다. (상태 코드 409)
    case conflict
    
    /// 요청한 미디어 형식을 지원하지 않음을 의미합니다. (상태 코드 415)
    case unsupportedMediaType
    
    /// 서버에서 내부 오류가 발생했음을 의미합니다. (상태 코드 500)
    case internalServerError
    
    /// 서버의 기능이 구현되지 않았음을 의미합니다. (상태 코드 501)
    case notImplemented
    
    /// 게이트웨이에서 잘못된 응답을 받았음을 의미합니다. (상태 코드 502)
    case badGateway
    
    /// 서비스가 일시적으로 사용 불가능함을 의미합니다. (상태 코드 503)
    case serviceUnavailable
    
    /// 게이트웨이 타임아웃을 의미합니다. (상태 코드 504)
    case gatewayTimeout
    
    /// 기타 네트워크 에러가 발생했음을 의미합니다. 원본 에러와 함께 처리합니다.
    case generic(Error)
    
    /// URL을 생성할 수 없음을 의미합니다. EndPoint에 잘못 기재된 요소는 없는지 확인하세요.
    case urlGeneration
    
    /// 기타 네트워크 오류가 발생했음을 의미합니다.
    case error(statusCode: Int)
}

extension BBNetworkError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .notConnected:
            return "네트워크 연결이 되어 있지 않습니다. 인터넷 연결을 확인하세요. 오프라인 상태에서는 일부 기능이 제한될 수 있습니다."
        case .cancelled:
            return "요청이 취소되었습니다. 사용자가 요청을 중단했거나, 네트워크 연결이 끊어졌을 수 있습니다."
        case .timeout:
            return "요청 시간이 초과되었습니다. 서버 응답이 너무 느리거나 네트워크가 불안정할 수 있습니다. 다시 시도해 주세요."
        case .badRequest:
            return "잘못된 요청입니다. 서버에 유효하지 않은 데이터를 보냈습니다. 입력값을 다시 확인하고 요청을 시도하세요. (상태 코드 400)"
        case .unauthorized:
            return "인증되지 않은 요청입니다. 로그인 상태가 유효하지 않거나 인증 토큰이 만료되었을 수 있습니다. 다시 로그인한 후 요청을 시도하세요. (상태 코드 401)"
        case .forbidden:
            return "접근이 금지되었습니다. 이 리소스에 대한 접근 권한이 없으므로 요청이 거부되었습니다. 권한이 있는지 확인해 주세요. (상태 코드 403)"
        case .notFound:
            return "요청한 리소스를 찾을 수 없습니다. 요청 URL이 올바른지, 또는 리소스가 존재하는지 확인하세요. (상태 코드 404)"
        case .methodNotAllowed:
            return "허용되지 않은 HTTP 메소드로 요청했습니다. 해당 리소스에서 지원하는 HTTP 메소드를 확인하세요. (상태 코드 405)"
        case .conflict:
            return "요청이 서버의 현재 상태와 충돌을 일으켰습니다. 리소스의 상태를 확인하고 다시 요청하세요. (상태 코드 409)"
        case .unsupportedMediaType:
            return "서버에서 지원하지 않는 미디어 형식의 요청입니다. 지원되는 형식을 확인하고 다시 시도하세요. (상태 코드 415)"
        case .internalServerError:
            return "서버 내부 오류가 발생했습니다. 서버 측에서 문제가 발생했을 수 있습니다. 잠시 후 다시 시도하세요. (상태 코드 500)"
        case .notImplemented:
            return "서버에서 아직 구현되지 않은 기능을 요청했습니다. (상태 코드 501)"
        case .badGateway:
            return "게이트웨이 또는 프록시 서버에서 잘못된 응답을 받았습니다. 잠시 후 다시 시도하세요. (상태 코드 502)"
        case .serviceUnavailable:
            return "서버가 과부하 상태이거나 유지보수 중입니다. 잠시 후 다시 시도하세요. (상태 코드 503)"
        case .gatewayTimeout:
            return "게이트웨이 서버가 응답하지 않아서 요청이 시간 초과되었습니다. 잠시 후 다시 시도하세요. (상태 코드 504)"
        case .generic(let error):
            return "알 수 없는 오류가 발생했습니다: \(error.localizedDescription)"
        case .urlGeneration:
            return "유효하지 않은 URL이 생성되었습니다. 요청 URL을 확인하세요."
        case .error(let statusCode):
            return "알 수 없는 HTTP 오류가 발생했습니다. (상태 코드: \(statusCode))"
        }
    }
}


public enum BBUploadError: Error {
    case fileNotFound
    case fileCorrupted
    case unauthorized
    case timeout
    case invalidServerResponse
    case uploadFailed
}


extension BBUploadError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "죄송합니다. 요청한 파일을 찾을 수 없습니다.\n 다시 시도해 주세요"
        case .fileCorrupted:
            return "업로드한 이미지 파일이 손상된 것으로 확인되었습니다.\n 다른 파일을 시도하거나 다시 업로드해 주세요."
        case .unauthorized:
            return "인증되지 않은 요청입니다.\n 로그인 상태가 유효하지 않거나 인증 토큰이 만료되었을 수 있습니다. 다시 로그인한 후 요청을 시도하세요."
        case .timeout:
            return "업로드 요청이 시간 초과되었습니다. 다시 시도해 주세요"
        case .invalidServerResponse:
            return "서버에서 잘못된 응답을 받았습니다."
        case .uploadFailed:
            return "업로드가 실패했습니다. 다시 시도해 주세요"
        }
    }
}


/// Firebase Crashlytics에 사용하는 Error Type입니다.
public enum BBCrashError: Error {
    /// 범위에 벗어나는 모든 경우에 발생하는 에러를 의미합니다.
    case indexOutBounds
    /// 강제 언래핑 실패할 경우에 발생하는 에러를 의미합니다.
    case forceUnwrapFailed
    /// 알 수 없는 에러일 경우 해당 에러를 사용합니다.
    case unknown
}


extension BBCrashError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .indexOutBounds:
            return "Index Out of Bounds Error"
        case .forceUnwrapFailed:
            return "Unexpectedly found nil while unwrapping an Optional value"
        case .unknown:
            return "Unknown Error"
        }
    }
}
