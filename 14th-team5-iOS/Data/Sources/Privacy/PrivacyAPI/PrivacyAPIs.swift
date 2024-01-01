//
//  PrivacyAPIs.swift
//  Data
//
//  Created by Kim dohyun on 1/1/24.
//

import Foundation



public enum PrivacyAPIs: API {
    case accountResign(String)
    case storeDetail
    
    var spec: APISpec {
        switch self {
        case let .accountResign(memeberId):
            return APISpec(method: .delete, url: "/members/\(memeberId)")
            
        case .storeDetail:
            return APISpec(method: .get, url: "https://itunes.apple.com/lookup")
        }
    }
}


