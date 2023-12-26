//
//  ProfileViewUseCase.swift
//  Data
//
//  Created by Kim dohyun on 12/25/23.
//

import Foundation

import RxCocoa
import RxSwift

public protocol ProfileViewUsecaseProtocol {
    func executeProfileMemberItems() -> Observable<ProfileMemberResponse>
    func execute() -> Observable<[FeedEntity]>
    func executeProfilePostItems(query: ProfilePostQuery, parameters: ProfilePostDefaultValue) -> Observable<ProfilePostResponse>
}


public final class ProfileViewUseCase: ProfileViewUsecaseProtocol {
    private let profileViewRepository: ProfileViewInterface
    
    public init(profileViewRepository: ProfileViewInterface) {
        self.profileViewRepository = profileViewRepository
    }
    
    public func executeProfileMemberItems() -> Observable<ProfileMemberResponse> {
        return profileViewRepository.fetchProfileMemberItems()
    }
    
    public func executeProfilePostItems(query: ProfilePostQuery, parameters: ProfilePostDefaultValue) -> Observable<ProfilePostResponse> {
        print("query : \(query) and paramter: \(parameters)")
        return profileViewRepository.fetchProfilePostItems(query: query, parameter: parameters)
    }
    
    public func execute() -> Observable<[FeedEntity]> {
        return profileViewRepository.fetchProfileFeedItems()
    }
    
    
    
}
