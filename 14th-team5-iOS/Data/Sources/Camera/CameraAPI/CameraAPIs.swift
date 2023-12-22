//
//  CameraAPIs.swift
//  Data
//
//  Created by Kim dohyun on 12/21/23.
//

import Foundation


public enum CameraAPIs: API {
    case uploadImageURL
    case presignedURL(String)
    case updateImage
    
    var spec: APISpec {
        switch self {
        case .uploadImageURL:
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/posts/image-upload-request")
        case let .presignedURL(url):
            return APISpec(method: .put, url: url)
        case .updateImage:
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/posts")
        }
    }
    
    
}
