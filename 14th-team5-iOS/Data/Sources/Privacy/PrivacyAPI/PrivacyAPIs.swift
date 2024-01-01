//
//  PrivacyAPIs.swift
//  Data
//
//  Created by Kim dohyun on 1/1/24.
//

import Foundation



public enum PrivacyAPIs: API {
    case storeDetail
    
    var spec: APISpec {
        switch self {
        case .storeDetail:
            return APISpec(method: .get, url: "https://itunes.apple.com/lookup")
        }
    }
}


