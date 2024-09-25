//
//  EEAPIEventMonitor.swift
//  BBNetwork
//
//  Created by 김건우 on 9/25/24.
//

import Foundation

import Alamofire

final class BBEventMonitor: EventMonitor {
    
    func requestDidFinish(_ request: Request) {
        print("[Reqeust BibbiNetwork LOG]")
        print("- URL : \((request.request?.url?.absoluteString ?? ""))")
        print("     - Method : \((request.request?.httpMethod ?? ""))")
        print("     - Headers \((request.request?.headers) ?? .default):")
    }
    
    public func request(
        _ request: DataRequest,
        didParseResponse response: DataResponse<Data?, AFError>
    ) {
        print("[Response BibbiNetwork LOG]")
        print("- URL : \((request.request?.url?.absoluteString ?? ""))")
        print("     - Results : \((response.result))")
        print("     - StatusCode : \(response.response?.statusCode ?? 0)")
        print("     - Data : \(response.data?.toPrettyPrintedString ?? "")")
    }
    
}

