//
//  ReactionMemberReactor.swift
//  App
//
//  Created by 마경미 on 07.01.24.
//

import Foundation
import Core
import Domain

import ReactorKit
import RxDataSources

final class ReactionMemberViewReactor: Reactor {
    enum Action {
        case makeDataSource
    }
    
    enum Mutation {
        case setMemberDataSource([FamilyMemberProfileSectionModel])
    }
    
    struct State {
        let emojiData: FetchedEmojiData
        var memberDataSource: [FamilyMemberProfileSectionModel] = []
    }
    
    let initialState: State
    let familyRepository: SearchFamilyMemberUseCaseProtocol
    
    init(initialState: State, familyRepository: SearchFamilyMemberUseCaseProtocol) {
        self.initialState = initialState
        self.familyRepository = familyRepository
    }
}

extension ReactionMemberViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .makeDataSource:
            let profiles: [ProfileData] = familyRepository.execute(memberIds: currentState.emojiData.memberIds) ?? []
            
            var items: [FamilyMemberProfileCellReactor] = []
            profiles.forEach {
                let member = FamilyMemberProfileResponse(memberId: $0.memberId, name: $0.name, imageUrl: $0.profileImageURL)
                items.append(FamilyMemberProfileCellReactor(member, isMe: false, cellType: .notArrow))
            }
            
            if  profiles.count != currentState.emojiData.memberIds.count {
                let len = currentState.emojiData.memberIds.count - profiles.count
                for _ in 0...(len - 1) {
                    let member = FamilyMemberProfileResponse(memberId: "", name: "알 수 없음")
                    items.append(FamilyMemberProfileCellReactor(member, isMe: false, cellType: .notArrow))
                }
            }
            
            let dataSource: FamilyMemberProfileSectionModel = .init(model: (), items: items)
            return Observable.just(Mutation.setMemberDataSource([dataSource]))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setMemberDataSource(dataSource):
            newState.memberDataSource = dataSource
        }
        return newState
    }
}
