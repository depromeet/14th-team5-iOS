//
//  API.swift
//  Data
//
//  Created by geonhui Yu on 12/17/23.
//

import Foundation

enum BibbiAPI {
    private static let _config: BibbiAPIConfigType = BibbiAPIConfig()
    static let hostApi: String = _config.hostApi
    
    // MARK: Common Headers
    enum Header: APIHeader {
        case auth(String)
        case contentForm
        case contentJson
        case contentMulti
        case acceptJson
        
        var key: String {
            switch self {
            case .auth: return "Authorization"
            case .contentForm: return "Content-Type"
            case .contentJson: return "Content-Type"
            case .contentMulti: return "Content-Type"
            case .acceptJson: return "Accept"
            }
        }
        
        var value: String {
            switch self {
            case .auth(let value): return "Bearer \(value)"
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
        var status: String?
        var code: Int?
        var errorCode: String?
    }
    
    struct BoolResponse: Codable {
        var status: String?
        var code: Int?
        var errorCode: String?
        var result: Bool?
    }
    
    struct CodableResponse<T: Codable>: Codable {
        var status: String?
        var code: Int?
        var errorCode: String?
        var result: T?
    }
}