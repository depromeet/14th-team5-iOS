//
//  PostAPIs.swift
//  Data
//
//  Created by 마경미 on 25.12.23.
//

import Core
import Foundation

public enum PostAPIs: API {
    case fetchPostList
    case fetchPostDetail(PostRequestDTO)
    
    public var spec: APISpec {
        switch self {
        case .fetchPostList:
            let urlString = "\(BibbiAPI.hostApi)/posts"
            return APISpec(method: .get, url: urlString)
        case let .fetchPostDetail(query):
            let urlString = "\(BibbiAPI.hostApi)/posts/\(query.postId)"
            return APISpec(method: .get, url: urlString)
        }
    }
}
