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
    
    func fetchProfileFeedItems() -> Observable<[FeedEntity]>
    func fetchProfileMemberItems() -> Observable<ProfileMemberResponse>
    
}
