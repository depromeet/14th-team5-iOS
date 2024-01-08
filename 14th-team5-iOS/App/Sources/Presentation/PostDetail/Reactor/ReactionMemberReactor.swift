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

final class ReactionMemberReactor: Reactor {
    enum Action {
        case makeDataSource
    }
    
    enum Mutation {
        case setMemberDataSource([FamilyMemberProfileSectionModel])
    }
    
    struct State {
        let reactionMemberIds: [String]
        var memberDataSource: [FamilyMemberProfileSectionModel] = []
    }
    
    let initialState: State
    let familyRepository: SearchFamilyMemberUseCaseProtocol
    
    init(initialState: State, familyRepository: SearchFamilyMemberUseCaseProtocol) {
        self.initialState = initialState
        self.familyRepository = familyRepository
    }
}

extension ReactionMemberReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .makeDataSource:
            let profiles: [ProfileData] = familyRepository.execute(memberIds: currentState.reactionMemberIds) ?? []
            var items: [FamilyMemberProfileCellReactor] = []
            profiles.forEach {
                let member = FamilyMemberProfileResponse(memberId: $0.memberId, name: $0.name, imageUrl: $0.profileImageURL)
                items.append(FamilyMemberProfileCellReactor(member, isMe: false))
            }
            
            let dataSource: FamilyMemberProfileSectionModel = .init(model: (), items: items)
            return Observable.just(Mutation.setMemberDataSource([dataSource]))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setMemberDataSource(dataSource):
            print(dataSource)
            newState.memberDataSource = dataSource
        }
        return newState
    }
}
