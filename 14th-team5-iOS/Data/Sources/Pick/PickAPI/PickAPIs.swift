//
//  PickAPIs.swift
//  Data
//
//  Created by 김건우 on 4/15/24.
//

import Foundation

enum PickAPIs: API {
    case pick(String)
    case whoDidIPick(String)
    case whoPickedMe(String)
    
    var spec: APISpec {
        switch self {
        case let .pick(memberId):
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/members/\(memberId)/pick")
        case let .whoDidIPick(memberId):
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/members/\(memberId)/picked")
        case let .whoPickedMe(memberId):
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/members/\(memberId)/pick")
        }
    }
}
