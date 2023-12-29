//
//  ProfileViewInterface.swift
//  Domain
//
//  Created by Kim dohyun on 12/25/23.
//

import Foundation

import RxCocoa
import RxSwift

public struct FeedEntity {
    public var imageURL: String
    public var descrption: String
    public var subTitle: String
    
    public init(imageURL: String, descrption: String, subTitle: String) {
        self.imageURL = imageURL
        self.descrption = descrption
        self.subTitle = subTitle
    }
}



public protocol ProfileViewInterface: AnyObject {
    var disposeBag: DisposeBag { get }
    
    func fetchProfileMemberItems() -> Observable<ProfileMemberResponse>
    func fetchProfilePostItems(query: ProfilePostQuery, parameter: ProfilePostDefaultValue) -> Observable<ProfilePostResponse>
    func fetchProfileAlbumImageURL(parameter: CameraDisplayImageParameters) -> Observable<CameraDisplayImageResponse?>
    func uploadProfileImageToPresingedURL(to url: String, imageData: Data) -> Observable<Bool>
    func updataProfileImageToS3(memberId: String, parameter: ProfileImageEditParameter) -> Observable<ProfileMemberResponse?>
    
}
