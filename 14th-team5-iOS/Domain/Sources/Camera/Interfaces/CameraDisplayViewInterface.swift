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
    case feed
    case profile
    case realEmoji
    
    
    public var location: String {
        switch self {
        case .feed:
            return "images/feed/"
        case .profile:
            return "images/profile/"
        case .realEmoji:
            return "images/real-emoji/"
        }
    }
}


public protocol CameraDisplayViewInterface: AnyObject {
    var disposeBag: DisposeBag { get }
    func generateDescrption(with keyword: String) -> Observable<Array<String>>
    func fetchFeedImageURL(parameters: CameraDisplayImageParameters) -> Observable<CameraDisplayImageResponse?>
    func uploadImageToS3(toURL url: String, imageData: Data) -> Observable<Bool>
    func combineWithTextImage(parameters: CameraDisplayPostParameters) -> Observable<CameraDisplayPostResponse?>
    
}
