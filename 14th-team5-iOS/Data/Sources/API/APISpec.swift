//
//  API.swift
//  Data
//
//  Created by geonhui Yu on 12/17/23.
//

import Foundation
import Alamofire
import RxSwift

// MARK: API Protocol
typealias BaseAPI = API
protocol API {
    var spec: APISpec { get }
}

// MARK: API Constants
enum APIConst {
    static let boundary = UUID().uuidString
}

// MARK: API Header Protocol
protocol APIHeader {
    var key: String { get }
    var value: String { get }
}

// MARK: API Prameter Protocol
protocol APIParameter {
    var key: String { get }
    var value: Any? { get }
}

// MARK: API Media Prameter
struct APIMediaParameter {
    let name: String
    let fileName: String
    let mimeType: String
    let fileURL: URL?
    let fileData: Data?
}

// MARK: API Result Type
typealias APIRes = APIResult
public enum APIResult {
    static let ok: Int = 200
    case success
    case failed
}

// MARK: API Error Protocol
protocol APIError: CustomNSError, Equatable {}

// MARK: API Specification
struct APISpec {
    let method: HTTPMethod
    let url: String
    
    init(method: HTTPMethod, url: String) {
        self.method = method
        self.url = url
    }
}
