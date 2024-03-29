//
//  LoadMyRealEmojiDTO.swift
//  Data
//
//  Created by 마경미 on 27.01.24.
//

import Foundation

import Core
import Domain

public struct MyRealEmojiListResponse: Codable {
    let myRealEmojiList: [MyRealEmojiList]
}

extension MyRealEmojiListResponse {
    func toDomain() -> [MyRealEmoji?] {
        var arr: [MyRealEmoji?] = [nil, nil, nil, nil, nil]
        myRealEmojiList.forEach {
            guard let chr = $0.type.last else {
                return
            }
            arr[(Int(String(chr)) ?? 1) - 1] = $0.toDomain()
        }
        return arr
    }
}

struct MyRealEmojiList: Codable {
    let realEmojiId: String
    let type: String
    let imageUrl: String
}

extension MyRealEmojiList {
    func toDomain() -> MyRealEmoji {
        return .init(realEmojiId: realEmojiId, type: Emojis.emoji(forString: type), imageUrl: imageUrl)
    }
}
