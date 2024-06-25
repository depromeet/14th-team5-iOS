//
//  CameraDisplayImageResponseDTO.swift
//  Data
//
//  Created by Kim dohyun on 6/7/24.
//

import Foundation

import Domain



public struct CameraDisplayImageResponseDTO: Decodable {
    public var imageURL: String?
    
    public enum CodingKeys: String, CodingKey {
        case imageURL = "url"
    }
}


extension CameraDisplayImageResponseDTO {
    
    public func toDomain() -> CameraPreSignedEntity? {
        return .init(imageURL: imageURL ?? "")
    }
}
