//
//  PostListAPIs.swift
//  Data
//
//  Created by 마경미 on 25.12.23.
//

import Foundation
import Core

enum PostListAPIs: API {
    case fetchPostList(PostListRequestDTO)
    
    var spec: APISpec {
        switch self {
        case let .fetchPostList(query):
            var urlString = "\(BibbiAPI.hostApi)/v1/posts"
            
            var queryParams: [String] = []
            queryParams.append("page=\(query.page)")
            queryParams.append("size=\(query.size)")
            queryParams.append("date=\(query.date)")
            queryParams.append("sort=\(query.sort)")
            
            if !queryParams.isEmpty {
                urlString += "?" + queryParams.joined(separator: "&")
            }
            
            return APISpec(method: .get, url: urlString)
        }
    }
}
