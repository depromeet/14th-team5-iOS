//
//  ProfileFeedCellReactor.swift
//  App
//
//  Created by Kim dohyun on 12/18/23.
//

import Foundation


import ReactorKit


public final class ProfileFeedCellReactor: Reactor {
    public var initialState: State
    
    public struct State {
        var imageURL: URL
        var emojiCount: String
        var date: String
        var commentCount: String
        var content: [String]
        var feedType: String?
        @Pulse var descrptionSection: [ProfileFeedDescrptionSectionModel] = [.feedDescrption([])]
    }
    
    public enum Action {
        case setFeedCellUpdateLayout
    }
    
    public enum Mutation {
        case setProfileDescrptionItems([ProfileFeedDescrptionSectionItem])
    }
    
    init(
        imageURL: URL,
        emojiCount: String,
        date: String,
        commentCount: String,
        content: [String]
    ) {
        self.initialState = State(
            imageURL: imageURL,
            emojiCount: emojiCount,
            date: date,
            commentCount: commentCount,
            content: content,
            feedType: nil
        )
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setFeedCellUpdateLayout:
            var sectionItem: [ProfileFeedDescrptionSectionItem] = []
            self.currentState.content.forEach {
                sectionItem.append(.feedDescrptionItem(ProfileFeedDescrptionCellReactor(content: $0)))
            }
            return .just(.setProfileDescrptionItems(sectionItem))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setProfileDescrptionItems(section):
            var sectionIndex = getSection(.feedDescrption([]))
            newState.descrptionSection[sectionIndex] = .feedDescrption(section)
        }
        
        return newState
    }
    
    
}

extension ProfileFeedCellReactor {
    func getSection(_ section: ProfileFeedDescrptionSectionModel) -> Int {
        var index: Int = 0
        
        for i in 0 ..< self.currentState.descrptionSection.count where self.currentState.descrptionSection[i].getSectionType() == section.getSectionType() {
            index = i
        }
        return index
    }
}
