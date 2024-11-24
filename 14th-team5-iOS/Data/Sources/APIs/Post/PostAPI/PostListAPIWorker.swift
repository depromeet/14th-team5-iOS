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
    
    /// 게시물 전체 조회하기 위한 Method 입니다.
    /// HTTP Method : GET
    /// - Parameters : PostListQueryDTO
    func fetchPostList(query: PostListQueryDTO) -> Observable<PostListResponseDTO?>
    {
        let spec = PostsAPIs.fetchPostList(query: query).spec
        
        return request(spec)
    }
    
    /// 게시물 단일 조회 하기 위한 Method 입니다.
    /// HTTP Method : GET
    /// - Parameters : PostId(게시글 고유 ID)
    /// - Returns : PostDetailResponseDTO
    func fetchPostDetail(postId: String) -> Observable<PostDetailResponseDTO?> {
        let spec = PostsAPIs.fetchPostDetail(postId: postId).spec
        
        return request(spec)
    }
    
    /// 게시물 생성을 하기 위한 Method 입니다.
    /// HTTP Method : POST
    /// - Parameters :
    ///     - query : CreatePostQuery
    ///     - body : CreatePostRequestDTO
    ///         - type: String
    ///         - available : Bool
    /// - Returns : CreatePostResponseDTO
    func createPost(query: CreatePostQuery, body: CreatePostRequestDTO) -> Observable<CreatePostResponseDTO?> {
        let spec = PostsAPIs.createPost(type: query.type, body: body).spec
        
        return request(spec)
    }
    
    /// 게시믈 이미지 업로드를 하기 위한 Presigend-URL API 요청 Method 입니다
    /// HTTP Method : POST
    /// - Returns : CreatePostPresignedURLResponseDTO
    func createPostPresignedURL(body: CreatePostPresignedURLReqeustDTO) -> Observable<CreatePostPresignedURLResponseDTO?> {
        let spec = PostsAPIs.createPostPresignedURL(body: body).spec
        
        return request(spec)
    }
    
    /// 피드 이미지를 S3 Bucket에 업로드 하기 위한 Method 입니다.
    /// HTTP Method : PUT
    /// - Parameters
    ///     - presignedURL : 서버에서 발급 받은 Presigned-URL
    ///     - image : Image Data Type
    /// - Returns : 업로드 성공 여부 확인 (Bool) Type
    func updateS3PostImageUpload(_ presignedURL: String, image: Data) -> Observable<Bool> {
        return upload(presignedURL, with: image)
    }
    
}







