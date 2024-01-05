//
//  API.swift
//  Data
//
//  Created by geonhui Yu on 12/17/23.
//

import Foundation

// MARK: APIs of AFP
typealias BibbiHeader = BibbiAPI.Header
typealias BibbiResponse = BibbiAPI.Response
typealias BibbiNoResponse = BibbiAPI.NoResponse
typealias BibbiBoolResponse = BibbiAPI.BoolResponse
typealias BibbiCodableResponse = BibbiAPI.CodableResponse


enum BibbiAPI {
    private static let _config: BibbiAPIConfigType = BibbiAPIConfig()
    static let hostApi: String = _config.hostApi
    
    // MARK: Common Headers
    enum Header: APIHeader {
        case xAppKey
        case auth(String)
        case xAuthToken(String)
        case contentForm
        case contentJson
        case contentMulti
        case acceptJson
        
        var key: String {
            switch self {
            case .xAppKey: return "X-APP-KEY"
            case .auth: return "Authorization"
            case .xAuthToken: return "X-AUTH-TOKEN"
            case .contentForm: return "Content-Type"
            case .contentJson: return "Content-Type"
            case .contentMulti: return "Content-Type"
            case .acceptJson: return "Accept"
            }
        }
        
        var value: String {
            switch self {
            case .xAppKey: return "9c61cc7b-0fe9-40eb-976e-6a74c8cb9092"
            case .auth(let value): return "Bearer \(value)"
            case .xAuthToken(let value): return "\(value)"
            case .contentForm: return "application/x-www-form-urlencoded"
            case .contentJson: return "application/json"
            case .contentMulti: return "multipart/form-data; boundary=\(APIConst.boundary)"
            case .acceptJson: return "application/json"
            }
        }
    }
    
    struct Response: Codable {
        let status: String?
        let code: Int?
        let errorCode: String?
        var result: APIResult {
            return self.code == APIRes.ok ? .success : .failed
        }
    }
    
    struct NoResponse: Codable {
//        var status: String?
//        var code: Int?
//        var errorCode: String?
    }
    
    struct BoolResponse: Codable {
        var status: String?
        var code: Int?
        var errorCode: String?
        var result: Bool?
    }
    
    struct CodableResponse<T: Codable>: Codable {
//        var status: String?
//        var code: String?
//        var message: String?
        var result: T?
    }
}
