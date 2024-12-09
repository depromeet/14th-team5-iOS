//
//  UpdateFamilyNameRequestDTO.swift
//  Data
//
//  Created by 김건우 on 8/11/24.
//

import Foundation

public struct UpdateFamilyNameRequestDTO: Encodable {
    let familyName: String?
    
    private enum CodingKeys: String, CodingKey {
        case familyName
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(familyName, forKey: .familyName)
    }
}
