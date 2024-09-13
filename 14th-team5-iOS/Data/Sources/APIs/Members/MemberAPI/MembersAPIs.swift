//
//  MembersAPIs.swift
//  Data
//
//  Created by Kim dohyun on 6/5/24.
//

import Foundation

import Core

enum MembersAPIs: API {
    case profileMember(String)
    case profilePost
    case profileAlbumUploadImageURL
    case profileUploadToPreSignedURL(String)
    case profileEditImage(String)
    case profileDeleteImage(String)
    case accountResign(String)
    
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
        case let .accountResign(memberId):
            return APISpec(method: .delete, url: "\(BibbiAPI.hostApi)/members/\(memberId)")
        
        }
    }
    
    
}

