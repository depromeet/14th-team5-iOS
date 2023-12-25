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
    func excute() -> Observable<[FeedEntity]>
}


public final class ProfileViewUseCase: ProfileViewUsecaseProtocol {
    private let profileViewRepository: ProfileViewInterface
    
    public init(profileViewRepository: ProfileViewInterface) {
        self.profileViewRepository = profileViewRepository
    }
    
    public func excute() -> Observable<[FeedEntity]> {
        return profileViewRepository.fetchProfileFeedItems()
    }
    
    
    
}
