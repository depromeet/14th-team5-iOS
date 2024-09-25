//
//  BibbiNetworkMonitor.swift
//  Data
//
//  Created by Kim dohyun on 7/10/24.
//

import Foundation

import Alamofire
import Core



final class BibbiNetworkMonitor: EventMonitor {
    
    var queue: DispatchQueue = {
        guard let bundleId = Bundle.main.bundleIdentifier else {
            fatalError("올바르지 않는 식별ID값 입니다.")
        }
        return DispatchQueue(label: bundleId)
    }()
    
    
    func requestDidFinish(_ request: Request) {
        print("[Reqeust BibbiNetwork LOG]")
        print("- URL : \((request.request?.url?.absoluteString ?? ""))")
        print("     - Method : \((request.request?.httpMethod ?? ""))")
        print("     - Headers \((request.request?.headers) ?? .default):")
    }
    
    public func request(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
        print("[Response BibbiNetwork LOG]")
        print("- URL : \((request.request?.url?.absoluteString ?? ""))")
        print("     - Results : \((response.result))")
        print("     - StatusCode : \(response.response?.statusCode ?? 0)")
        print("     - Data : \(response.data?.toPrettyPrintedString ?? "")")
    }
}
