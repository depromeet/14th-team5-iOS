//
//  RealEmojiAPIWorker.swift
//  Data
//
//  Created by 마경미 on 22.01.24.
//

import Foundation

import Core

import Alamofire
import RxSwift

typealias PostRealEmojiWorker = PostRealEmojiAPIs.Worker
extension PostRealEmojiWorker {
    
    /// post에 등록된 리얼 이모지를 조회합니다.
    /// HTTP Method: GET
    /// - Parameters: FetchRealEmojiQuery
    /// - Returns: FetchRealEmojiListResponseDTO?
    func fetchRealEmoji(
        _ postId: String
    ) -> Observable<FetchRealEmojiListResponseDTO?> {
        let spec = PostRealEmojiAPIs.fetchRealEomjiReactions(postId).spec
        
        return request(spec)
    }
    
    /// post에 리얼 이모지 리액션을 등록합니다.
    /// HTTP Method: POST
    /// - Parameters: CreateReactionQuery, CreateReactionRequest
    /// - Returns: AddRealEmojiResponseDTO?
    func addRealEmoji(
        _ postId: String,
        body: AddRealEmojiRequestDTO
    ) -> Observable<AddRealEmojiResponseDTO?> {
        let spec = PostRealEmojiAPIs.addRealEmojiReaction(postId, body).spec
        
        return request(spec)
    }
    
    /// post에 리얼 이모지 리액션을 삭제합니다.
    /// HTTP Method: POST
    /// - Parameters: RemoveRealEmojiQuery
    /// - Returns: RemoveRealEmojiResponseDTO?
    func removeRealEmoji(
        _ postId: String,
        _ realEmojiId: String
    ) -> Observable<RemoveRealEmojiResponseDTO?> {
        let spec = PostRealEmojiAPIs.removeRealEmojiReactions(postId, realEmojiId).spec
        
        return request(spec)
    }
}
