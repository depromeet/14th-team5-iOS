//
//  ProfileAPIs.swift
//  Data
//
//  Created by Kim dohyun on 12/25/23.
//

import Foundation

import Core


enum ProfileAPIs: API {
    case profileMember(String)
    case profilePost
    case profileAlbumUploadImageURL
    case profileUploadToPreSignedURL(String)
    case profileEditImage(String)
    case profileDeleteImage(String)
    
    var spec: APISpec {
        switch self {
        case let .profileMember(memberId):
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/members/\(memberId)")
        case .profilePost:
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/posts")
        case .profileAlbumUploadImageURL:
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/members/image-upload-request")
        case let .profileUploadToPreSignedURL(url):
            return APISpec(method: .put, url: url)
        case let .profileEditImage(memberId):
            return APISpec(method: .put, url: "\(BibbiAPI.hostApi)/members/profile-image-url/\(memberId)")
        case let .profileDeleteImage(memberId):
            return APISpec(method: .delete, url: "\(BibbiAPI.hostApi)/members/profile-image-url/\(memberId)")
        
        }
    }
    
    
}
