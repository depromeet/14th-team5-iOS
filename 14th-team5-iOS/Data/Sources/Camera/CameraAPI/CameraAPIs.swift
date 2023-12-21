//
//  CameraAPIs.swift
//  Data
//
//  Created by Kim dohyun on 12/21/23.
//

import Foundation


enum CameraAPIs: API {
    case uploadImageURL
    
    var spec: APISpec {
        switch self {
        case .uploadImageURL:
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/v1/posts/image-upload-request")
        }
    }
    
    
}
