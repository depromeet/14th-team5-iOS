//
//  RecentFamilyPostRequestDTO.swift
//  Data
//
//  Created by 마경미 on 05.06.24.
//

import Foundation

struct RecentFamilyPostParameter: Codable {
    let date: String = Date().toFormatString(with: "yyyy-MM-dd")
}
