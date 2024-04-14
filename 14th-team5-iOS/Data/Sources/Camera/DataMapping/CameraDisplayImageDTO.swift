//
//  CameraDisplayImageDTO.swift
//  Domain
//
//  Created by Kim dohyun on 12/21/23.
//

import Foundation
import Domain



public struct CameraDisplayImageDTO: Decodable {
    public var imageURL: String?
    
    public enum CodingKeys: String, CodingKey {
        case imageURL = "url"
    }
}


extension CameraDisplayImageDTO {
    
    public func toDomain() -> CameraDisplayImageResponse? {
        return .init(imageURL: imageURL ?? "")
    }
}
