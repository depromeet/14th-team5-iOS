//
//  CameraAPIs.swift
//  Data
//
//  Created by Kim dohyun on 12/21/23.
//

import Foundation

import Domain

public enum CameraAPIs: API {
    case uploadImageURL
    case presignedURL(String)
    case updateImage
    case uploadProfileImageURL
    case editProfileImage(String)
    case uploadRealEmojiURL(String)
    case updateRealEmojiImage(String)
    case reloadRealEmoji(String)
    case modifyRealEmojiImage(String, String)
    
    var spec: APISpec {
        switch self {
        case .uploadProfileImageURL:
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/members/image-upload-request")
        case let .editProfileImage(memberId):
            return APISpec(method: .put, url: "\(BibbiAPI.hostApi)/members/profile-image-url/\(memberId)")
        case .uploadImageURL:
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/posts/image-upload-request")
        case let .presignedURL(url):
            return APISpec(method: .put, url: url)
        case .updateImage:
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/posts")
        case let .uploadRealEmojiURL(memberId):
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/members/\(memberId)/real-emoji/image-upload-request")
        case let .updateRealEmojiImage(memberId):
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/members/\(memberId)/real-emoji")
        case let .reloadRealEmoji(memberId):
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/members/\(memberId)/real-emoji")
        case let .modifyRealEmojiImage(memberId, realEmojiId):
            return APISpec(method: .put, url: "\(BibbiAPI.hostApi)/members/\(memberId)/real-emoji/\(realEmojiId)")
        }
    }
    
    
}
