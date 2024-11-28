//
//  MemberRealEmojiWorker.swift
//  Data
//
//  Created by 마경미 on 26.11.24.
//

import RxSwift

typealias MemberRealEmojiWorker = MemberRealEmojiAPIs.Worker
extension MemberRealEmojiWorker {
    
    /// 회원에 등록된 리얼 이모지를 조회하는 Method입니다.
    /// HTTP Method: GET
    /// - Parameters: memberId: String
    /// - Returns: MyRealEmojiResponseDTO?
    func fetchMyRealEmoji(memberId: String) -> Observable<MyRealEmojiResponseDTO?> {
        let spec = MemberRealEmojiAPIs.fetchMemberRealEmoji(memberId).spec
        
        return request(spec)
    }
}
