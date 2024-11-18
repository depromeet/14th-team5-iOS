//
//  CameraRepository.swift
//  Domain
//
//  Created by 김도현 on 11/18/24.
//

import Foundation

import RxSwift

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
    
    /// CREATE 메서드
    func createFeedImage(query: CreateFeedQuery, body: CreateFeedRequest) -> Observable<CameraPostEntity?>
    func createProfileImagePresignedURL(body: CreatePresignedURLRequest) -> Observable<CameraPreSignedEntity?>
    func createEmojiImagePresignedURL(memberID: String, body: CreatePresignedURLRequest) -> Observable<CameraRealEmojiPreSignedEntity?>
    func createEmojiImage(memberId: String, body: CreateEmojiImageRequest) -> Observable<CameraCreateRealEmojiEntity?>
    
    /// FETCH 메서드
    func fetchEmojiList(memberId: String) -> Observable<[CameraRealEmojiImageItemEntity?]>
    func fetchDailyMissonItem() -> Observable<CameraTodayMssionEntity?>
    
    /// UPDATE 메서드
    func updateUserProfileImage(memberId: String, body: UpdateProfileImageRequest) -> Observable<MembersProfileEntity?>
    func updateEmojiImage(memberId: String, realEmojiId: String, body: UpdateRealEmojiImageRequest) -> Observable<CameraUpdateRealEmojiEntity?>
    
    /// UPLOAD 메서드
    func uploadImageToS3Bucket(_ presignedURL: String, image: Data) -> Observable<Bool>
}
