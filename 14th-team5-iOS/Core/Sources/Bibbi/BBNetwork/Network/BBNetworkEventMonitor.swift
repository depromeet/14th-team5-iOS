//
//  BBNetworkInterceptor.swift
//  Core
//
//  Created by 김건우 on 10/5/24.
//

import Foundation

import Alamofire

// MARK: - Event Monitor

public protocol BBNetworkEventMonitor: EventMonitor { }

extension BBNetworkEventMonitor {
    func isSuccessfulStatusCode(_ dataRespnse: DataResponse<Data?, AFError>) -> Bool {
        guard
            let statusCode = dataRespnse.response?.statusCode,
            (200..<300) ~= statusCode else {
            return false
        }
        return true
    }
}


// MARK: - Default Logger

public final class BBNetworkDefaultLogger {
    public init() { }
    public var queue = DispatchQueue(label: "com.bibbi.logger.queue")
}

extension BBNetworkDefaultLogger: BBNetworkEventMonitor {
    
    public func requestDidFinish(_ request: Request) {
        var httpLog = "-- [BBNetwork Request Log] ----------------------------\n"
        
        let urlString = request.request?.url?.absoluteString ?? "(unknown)"
        let httpMethod = request.request?.httpMethod ?? "(unknown)"
        
        var allHeadersString = "[\n"
        request.request?.allHTTPHeaderFields?
            .forEach { allHeadersString.append("\t ・ \($0.key): \($0.value)\n") }
        allHeadersString.append("]")
        
        let httpBody = request.request?.httpBody?.toPrettyPrintedString
        
        httpLog.append("- URL: \(urlString)\n")
        httpLog.append("- METHOD: \(httpMethod)\n")
        httpLog.append("- HEADERS: \(allHeadersString)\n")
        if let httpBody = httpBody {
            httpLog.append("- HTTP BODY: \(httpBody)\n")
        }
        
        BBLogger.logInfo(category: "Network", message: httpLog)
    }
    
    public func request(
        _ request: DataRequest,
        didParseResponse response: DataResponse<Data?, AFError>
    ) {
        guard isSuccessfulStatusCode(response) else { return }
        
        let urlString = request.request?.url?.absoluteString ?? "(unknown)"
        let statusCode = response.response?.statusCode.description ?? "(unknown)"
        let httpMethod = request.request?.httpMethod ?? "(unknown)"

        var httpLog = "-- [BBNetwork Response Log] ----------------------------\n"
        
        var allHeadersString = "[\n"
        request.request?.allHTTPHeaderFields?
            .forEach { allHeadersString.append("\t ・ \($0.key): \($0.value)\n") }
        allHeadersString.append("]")
        
        var responseDataString = ""
        responseDataString.append(response.data?.toPrettyPrintedString ?? "(unknown)")
        
        httpLog.append("- URL: \(urlString)\n")
        httpLog.append("- METHOD: \(httpMethod)\n")
        httpLog.append("- HEADERS: \(allHeadersString)\n")
        httpLog.append("- STATUS CODE: \(statusCode)\n")
        httpLog.append("- RESONSE DATA: \(responseDataString)\n")
        
        BBLogger.logInfo(category: "Network", message: httpLog)
    }
    
    public func request(
        _ request: Request,
        didFailTask task: URLSessionTask,
        earlyWithError error: AFError
    ) { }
    
}
