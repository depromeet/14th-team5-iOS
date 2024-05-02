//
//  CameraDisplayViewInterface.swift
//  Domain
//
//  Created by Kim dohyun on 12/26/23.
//

import Foundation

import RxCocoa
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


public protocol CameraDisplayViewInterface: AnyObject {
    var disposeBag: DisposeBag { get }
    func generateDescrption(with keyword: String) -> Observable<Array<String>>
    func fetchFeedImageURL(parameters: CameraDisplayImageParameters) -> Observable<CameraDisplayImageResponse?>
    func uploadImageToS3(toURL url: String, imageData: Data) -> Observable<Bool>
    func combineWithTextImage(parameters: CameraDisplayPostParameters, query: CameraMissionFeedQuery) -> Observable<CameraDisplayPostResponse?>
    
}
