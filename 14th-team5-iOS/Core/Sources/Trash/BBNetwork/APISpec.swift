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
@available(*, deprecated, renamed: "BBAPI")
public typealias BaseAPI = API

@available(*, deprecated, renamed: "BBAPI")
public protocol API {
    var spec: APISpec { get }
}

// MARK: API Constants
public enum APIConst {
    static let boundary = UUID().uuidString
}

// MARK: API Header Protocol
public protocol APIHeader {
    var key: String { get }
    var value: String { get }
}

// MARK: API Prameter Protocol
public protocol APIParameter {
    var key: String { get }
    var value: Any? { get }
}

// MARK: API Media Prameter
public struct APIMediaParameter {
    let name: String
    let fileName: String
    let mimeType: String
    let fileURL: URL?
    let fileData: Data?
}

// MARK: API Result Type
public typealias APIRes = APIResult
public  enum APIResult {
    static let ok: Int = 200
    case success
    case failed
}

// MARK: API Error Protocol

@available(*, deprecated, renamed: "BBAPIError")
public protocol APIError: CustomNSError, Equatable {}

// MARK: API Specification

@available(*, deprecated, renamed: "BBAPISpec")
public struct APISpec {
    public let method: HTTPMethod
    public let url: String
    
    public init(method: HTTPMethod, url: String) {
        self.method = method
        self.url = url
    }
}
