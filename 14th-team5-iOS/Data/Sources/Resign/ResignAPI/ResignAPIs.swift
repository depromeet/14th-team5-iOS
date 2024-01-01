//
//  ResignAPIs.swift
//  Data
//
//  Created by Kim dohyun on 1/2/24.
//

import Foundation


public enum ResignAPIs: API {
    case accountResign(String)
    
    var spec: APISpec {
        switch self {
        case let .accountResign(memeberId):
            return APISpec(method: .delete, url: "/members/\(memeberId)")
        }
    }
    
}
