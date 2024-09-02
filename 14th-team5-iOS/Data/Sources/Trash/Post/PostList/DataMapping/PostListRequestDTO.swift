//
//  PostListRequestDTO.swift
//  Data
//
//  Created by Kim dohyun on 6/6/24.
//

import Foundation


struct PostListRequestDTO: Codable {
    let page: Int
    let size: Int
    let date: String
    let memberId: String?
    let sort: String
    let type: String
}
