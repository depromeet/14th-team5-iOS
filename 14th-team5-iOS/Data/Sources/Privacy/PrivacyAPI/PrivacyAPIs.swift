//
//  PrivacyAPIs.swift
//  Data
//
//  Created by Kim dohyun on 1/1/24.
//

import Foundation
import Core


public enum PrivacyAPIs: API {
    case bibbiAppInfo
    case accountFamilyResign
    
    public var spec: APISpec {
        switch self {
        case .bibbiAppInfo:
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/me/app-version")
        case .accountFamilyResign:
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/me/quit-family")
        }
    }
}


