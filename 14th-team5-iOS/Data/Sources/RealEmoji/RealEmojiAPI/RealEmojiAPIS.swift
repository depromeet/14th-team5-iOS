//
//  RealEmojiAPIS.swift
//  Data
//
//  Created by 마경미 on 22.01.24.
//

import Foundation
import Core

public enum RealEmojiAPIS: API {
    case fetchRealEmojiList(FetchRealEmojiListParameter)
    case loadMyRealEmoji
    case addRealEmoji(AddRealEmojiParameters)
    
    var spec: APISpec {
        switch self {
        case .addRealEmoji(let parameter):
            let urlString = "\(BibbiAPI.hostApi)/posts/\(parameter.postId)/real-emoji"
            return APISpec(method: .post, url: urlString)
        case .fetchRealEmojiList(let parameter):
            let urlString = "\(BibbiAPI.hostApi)/posts/\(parameter.postId)/real-emoji"
            return APISpec(method: .get, url: urlString)
        case .loadMyRealEmoji:
            let memberId = App.Repository.member.memberID.value
            let urlString = "\(BibbiAPI.hostApi)/members/\(memberId ?? "")/real-emoji"
            return APISpec(method: .get, url: urlString)
        }
    }
}
