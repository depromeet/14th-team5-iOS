//
//  PostAPIWorker.swift
//  Data
//
//  Created by 마경미 on 25.12.23.
//

import Foundation

import Core
import Domain

import Alamofire
import RxSwift


typealias PostAPIWorker = PostsAPIs.Worker



extension PostAPIWorker {
    
    func fetchPostList(query: PostListQuery) -> Observable<PostListResponseDTO?>
    {
        let spec = PostsAPIs.fetchPostList(
            page: query.page,
            size: query.size,
            date: query.date,
            memberId: query.memberId,
            sort: query.sort,
            type: query.type.rawValue
        ).spec
        
        return request(spec)
    }
    
//    func createPost(type: String) -> Observable<>
}







