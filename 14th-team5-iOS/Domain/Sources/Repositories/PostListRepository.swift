//
//  PostListRepository.swift
//  Domain
//
//  Created by 마경미 on 25.12.23.
//

import Foundation
import RxSwift

public protocol PostListRepositoryProtocol {
    /// FETCH
    func fetchPostList(query: PostListQuery) -> Observable<PostListPageEntity?>
    func fetchPostDetailItem(postId: String) -> Observable<PostDetailEntity?>
    /// CREATE
    func createPostItem(query: CreatePostQuery, body: CreatePostRequest) -> Observable<CreatePostEntity?>
    func createPostPresignedURLItem(body: CreatePostPresignedURLRequest) -> Observable<CreatePostPresignedURLEntity?>
    
    /// UPLOAD
    func uploadPostImageToS3Bucket(_ presignedURL: String, image: Data) -> Observable<Bool>
}
