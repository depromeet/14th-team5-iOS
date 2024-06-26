//
//  PrivacyAPIs.swift
//  Data
//
//  Created by Kim dohyun on 1/1/24.
//

import Core
import Foundation



enum PrivacyAPIs: API {
    case bibbiAppInfo
    case accountFamilyResign
    
    var spec: APISpec {
        switch self {
        case .bibbiAppInfo:
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/me/app-version")
        case .accountFamilyResign:
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/me/quit-family")
        }
    }
}


