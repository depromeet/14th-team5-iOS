//
//  ProfileViewReactor.swift
//  App
//
//  Created by Kim dohyun on 12/17/23.
//

import Foundation

import Domain
import ReactorKit


public final class ProfileViewReactor: Reactor {
    public var initialState: State
    private let profileUseCase: ProfileViewUsecaseProtocol
    
    public enum Action {
        case viewDidLoad
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case setFeedCategroySection([ProfileFeedSectionItem])
        case setProfileMemberItems(ProfileMemberResponse)
    }
    
    public struct State {
        var isLoading: Bool
        @Pulse var feedSection: [ProfileFeedSectionModel]
        @Pulse var profileMemberEntity: ProfileMemberResponse?
    }
    
    init(profileUseCase: ProfileViewUsecaseProtocol) {
        self.profileUseCase = profileUseCase
        self.initialState = State(
            isLoading: false,
            feedSection: [.feedCategory([])],
            profileMemberEntity: nil
        )
    }
    
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .concat(
                .just(.setLoading(true)),
                profileUseCase.executeProfileMemberItems()
                    .asObservable()
                    .flatMap { entity -> Observable<ProfileViewReactor.Mutation> in
                        return .just(.setProfileMemberItems(entity))
                    },
                
                profileUseCase.execute()
                    .asObservable()
                    .flatMap { items -> Observable<ProfileViewReactor.Mutation> in
                        var sectionItems: [ProfileFeedSectionItem] = []
                        
                        items.forEach {
                            sectionItems.append(.feedCategoryItem(ProfileFeedCellReactor(imageURL: $0.imageURL, title: $0.descrption, date: $0.subTitle)))
                        }
                        return .concat(
                            .just(.setFeedCategroySection(sectionItems)),
                            .just(.setLoading(false))
                        )
                    }
            )
            
        }
    }
    
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        case let .setFeedCategroySection(section):
            let sectionIndex = getSection(.feedCategory([]))
            newState.feedSection[sectionIndex] = .feedCategory(section)
            
        case let .setProfileMemberItems(entity):
            print("ProfileMember Entity: \(entity)")
            newState.profileMemberEntity = entity
        }
        
        return newState
    }
    
}


extension ProfileViewReactor {
 
    func getSection(_ section: ProfileFeedSectionModel) -> Int {
        var index: Int = 0
        
        for i in 0 ..< self.currentState.feedSection.count where self.currentState.feedSection[i].getSectionType() == section.getSectionType() {
            index = i
        }
        
        return index
    }
}
