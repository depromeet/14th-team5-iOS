//
//  API.swift
//  Data
//
//  Created by geonhui Yu on 12/17/23.
//

import Foundation
import Core

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
        case auth(String)
        case xAppKey
        case xAuthToken(String)
        case contentForm
        case contentJson
        case contentMulti
        case acceptJson
        case xUserPlatform
        case xAppVersion
        case xUserID
        
        var key: String {
            switch self {
            case .auth: return "Authorization"
            case .xAppKey: return "X-APP-KEY"
            case .xAuthToken: return "X-AUTH-TOKEN"
            case .contentForm: return "Content-Type"
            case .contentJson: return "Content-Type"
            case .contentMulti: return "Content-Type"
            case .acceptJson: return "Accept"
            case .xUserPlatform: return "X-USER-PLATFORM"
            case .xAppVersion: return "X-APP-VERSION"
            case .xUserID: return "X-USER-ID"
            }
        }
        
        var value: String {
            switch self {
            case .auth(let value): return "Bearer \(value)"
            case .xAppKey: return "32215db9-5bd3-48d4-8f06-243ae1eb6352"
            case .xAuthToken(let value): return "\(value)"
            case .contentForm: return "application/x-www-form-urlencoded"
            case .contentJson: return "application/json"
            case .contentMulti: return "multipart/form-data; boundary=\(APIConst.boundary)"
            case .acceptJson: return "application/json"
            case .xUserPlatform: return "iOS"
            case .xAppVersion: return "\(Bundle.main.appVersion)"
            case .xUserID: return "\(App.Repository.member.memberID.value ?? "송영민짱")"
            }
        }
        
        static var baseHeaders: [Self] {
            return [.xAppKey, .xAppVersion, .xUserPlatform, .xUserID]
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
