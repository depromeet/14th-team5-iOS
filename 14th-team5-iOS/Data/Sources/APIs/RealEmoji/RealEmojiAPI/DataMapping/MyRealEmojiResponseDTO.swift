//
//  LoadMyRealEmojiDTO.swift
//  Data
//
//  Created by 마경미 on 27.01.24.
//

import Foundation

import Core
import Domain

struct MyRealEmojiList: Codable {
    let realEmojiId: String
    let type: String
    let imageUrl: String

    func toDomain() -> MyRealEmojiEntity {
        return .init(realEmojiId: realEmojiId, type: Emojis.emoji(forString: type), imageUrl: imageUrl)
    }
}

struct MyRealEmojiResponseDTO: Codable {
    let myRealEmojiList: [MyRealEmojiList]
    
    func toDomain() -> [MyRealEmojiEntity?] {
        var arr: [MyRealEmojiEntity?] = [nil, nil, nil, nil, nil]
        myRealEmojiList.forEach {
            guard let chr = $0.type.last else {
                return
            }
            arr[(Int(String(chr)) ?? 1) - 1] = $0.toDomain()
        }
        return arr
    }
}
