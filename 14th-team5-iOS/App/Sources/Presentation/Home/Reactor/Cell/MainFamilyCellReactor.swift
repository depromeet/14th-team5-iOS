//
//  MainFamilyCellReactor.swift
//  App
//
//  Created by 마경미 on 21.04.24.
//

import Foundation

import Core
import Domain

import ReactorKit

enum RankBadge: Int {
    case one = 1
    case two = 2
    case three = 3
}

final class MainFamilyCellReactor: Reactor {
    
    // MARK: - Action
    enum Action {
        case fetchData
        case pickButtonTapped
    }
    
    // MARK: - Mutation
    enum Mutation {
        case setData
        case setPickButtonAppearent(Bool)
    }
    
    // MARK: - State
    struct State {
        let profileData: FamilyMemberProfileEntity
        var profile: (imageUrl: String?, name: String) = (nil, .none)
        var rank: Int? = nil
        var isShowBirthdayBadge: Bool = false
        var isShowPickButton: Bool = false
    }
    
    // MARK: - Properties
    let initialState: State
    let provider: ServiceProviderProtocol
    
    // MARK: - Intializer
    init(_ profileData: FamilyMemberProfileEntity, service provider: ServiceProviderProtocol) {
        self.initialState = State(profileData: profileData)
        self.provider = provider
    }
    
    // MARK: - Transofrm
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let homeMutation = provider.mainService.event
            .flatMap { event in
                switch event {
                case let .showPickButton(show, id):
                    guard id == self.currentState.profileData.memberId else {
                        return Observable<Mutation>.empty()
                    }
                    return Observable<Mutation>.just(.setPickButtonAppearent(show))
                
                default:
                    return Observable<Mutation>.empty()
                }
            }
        
        return Observable<Mutation>.merge(mutation, homeMutation)
    }
    
    // MARK: - Mutate
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchData:
            return Observable.just(.setData)
            
        case .pickButtonTapped:
            provider.mainService.pickButtonTapped(
                name: currentState.profileData.name,
                memberId: currentState.profileData.memberId
            )
            return Observable<Mutation>.empty()
        }
    }
    
    // MARK: - Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setData:
            newState.profile = (currentState.profileData.profileImageURL, currentState.profileData.name)
            newState.rank = currentState.profileData.postRank
            newState.isShowBirthdayBadge = currentState.profileData.isShowBirthdayMark
            newState.isShowPickButton = currentState.profileData.isShowPickIcon
            
        case let .setPickButtonAppearent(show):
            newState.isShowPickButton = show
        }
        
        return newState
    }
    
}

// MARK: - Extensions
extension MainFamilyCellReactor: Equatable {
    
    static func == (lhs: MainFamilyCellReactor, rhs: MainFamilyCellReactor) -> Bool {
        lhs.initialState.id == rhs.initialState.id
    }
    
}

extension MainFamilyCellReactor.State: Identifiable {
    var id: UUID { UUID() }
}
