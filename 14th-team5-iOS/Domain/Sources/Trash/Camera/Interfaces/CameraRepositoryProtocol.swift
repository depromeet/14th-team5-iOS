//
//  CameraRepositoryProtocol.swift
//  Domain
//
//  Created by Kim dohyun on 6/7/24.
//

import Foundation

import RxSwift
import RxCocoa

public enum UploadLocation {
    case survival
    case mission
    case profile
    case realEmoji
  
  public var isRealEmojiType: Bool {
    switch self {
    case .realEmoji:
      return true
    default:
      return false
    }
  }
    
    
    public var location: String {
        switch self {
        case .survival, .mission:
            return "images/feed/"
        case .profile:
            return "images/profile/"
        case .realEmoji:
            return "images/real-emoji/"
        }
    }
    
    public var asPostType: PostType {
        switch self {
        case .survival:
            return .survival
        case .mission:
            return .mission
        default:
            return .survival
        }
    }
  
    public func setTitle() -> String {
      switch self {
      case .survival:
        return "생존 카메라"
      case .mission:
        return "미션 카메라"
      case .profile:
        return "카메라"
      case .realEmoji:
        return "셀피 이미지"
      }
    }
}



public protocol CameraRepositoryProtocol {
    var disposeBag: DisposeBag { get }
    
    var accessToken: String { get }
    func addPresignedeImageURL(parameters: CameraDisplayImageParameters) -> Single<CameraPreSignedEntity?>
    func uploadImageToS3(to url: String, from image: Data) -> Single<Bool>
    func editProfleImageToS3(memberId: String, parameter: ProfileImageEditParameter) -> Single<MembersProfileEntity?>
    func fetchRealEmojiImageURL(memberId: String, parameters: CameraRealEmojiParameters) -> Single<CameraRealEmojiPreSignedEntity?>
    func uploadRealEmojiImageToS3(memberId: String, parameters: CameraCreateRealEmojiParameters) -> Single<CameraCreateRealEmojiEntity?>
    func fetchRealEmojiItems() -> Single<[CameraRealEmojiImageItemEntity?]>
    func updateRealEmojiImage(memberId: String, realEmojiId: String, parameters: CameraUpdateRealEmojiParameters) -> Single<CameraUpdateRealEmojiEntity?>
    func fetchTodayMissionItem() -> Single<CameraTodayMssionEntity?>
    func combineWithTextImage(parameters: CameraDisplayPostParameters, query: CameraMissionFeedQuery) -> Single<CameraPostEntity?>
}
