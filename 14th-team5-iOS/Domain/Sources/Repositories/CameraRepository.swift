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
    case account
  
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
        default:
            return ""
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
      default:
          return ""
      }
    }
}

public protocol CameraRepositoryProtocol {
    var disposeBag: DisposeBag { get }

    func createEmojiImagePresignedURL(memberID: String, body: CreatePresignedURLRequest) -> Observable<CameraRealEmojiPreSignedEntity?>
    func createEmojiImage(memberId: String, body: CreateEmojiImageRequest) -> Observable<CameraCreateRealEmojiEntity?>
    
    /// FETCH 메서드
    func fetchEmojiList(memberId: String) -> Observable<[CameraRealEmojiImageItemEntity?]>
    func updateEmojiImage(memberId: String, realEmojiId: String, body: UpdateRealEmojiImageRequest) -> Observable<CameraUpdateRealEmojiEntity?>
}
