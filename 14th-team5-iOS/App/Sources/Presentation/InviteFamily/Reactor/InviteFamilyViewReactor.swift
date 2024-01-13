//
//  LinkShareViewReactor.swift
//  App
//
//  Created by 김건우 on 12/11/23.
//

import Foundation

import Core
import Data
import Domain
import Differentiator
import ReactorKit
import RxSwift

typealias FamilyMemberProfileSectionModel = SectionModel<Void, FamilyMemberProfileCellReactor>

public final class InviteFamilyViewReactor: Reactor {
    // MARK: - Action
    public enum Action {
        case didTapShareButton
        case fetchFamilyMemebers
    }
    
    // MARK: - Mutate
    public enum Mutation {
        case setSharePanel(String)
        case setCopySuccessToastMessageView
        case setFetchFailureTaostMessageView
        case injectFamilyMembers([FamilyMemberProfileCellReactor])
    }
    
    // MARK: - State
    public struct State {
        @Pulse var familyInvitationUrl: URL?
        @Pulse var shouldPresentCopySuccessToastMessageView: Bool
        @Pulse var shouldPresentFetchFailureToastMessageView: Bool
        var displayMemberCount: Int
        var displayFamilyMembers: [FamilyMemberProfileSectionModel]
    }
    
    // MARK: - Properties
    public let initialState: State
    
    public let inviteFamilyUseCase: FamilyViewUseCaseProtocol
    public let provider: GlobalStateProviderProtocol
    
    private let memberId: String? = App.Repository.member.memberID.value
    
    // MARK: - Intializer
    init(usecase: FamilyViewUseCaseProtocol, provider: GlobalStateProviderProtocol) {
        self.initialState = State(
            familyInvitationUrl: nil,
            shouldPresentCopySuccessToastMessageView: false,
            shouldPresentFetchFailureToastMessageView: false,
            displayMemberCount: 0,
            displayFamilyMembers: []
        )
        
        self.inviteFamilyUseCase = usecase
        self.provider = provider
    }
    
    // MARK: - Transform
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = provider.activityGlobalState.event
            .flatMap { event -> Observable<Mutation> in
                switch event {
                case .didTapCopyInvitationUrlAction:
                    return Observable<Mutation>.just(.setCopySuccessToastMessageView)
                }
            }
        
        return Observable<Mutation>.merge(mutation, eventMutation)
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapShareButton:
            return inviteFamilyUseCase.executeFetchInvitationUrl()
                .map {
                    guard let invitationLink = $0?.url else {
                        return .setFetchFailureTaostMessageView
                    }
                    return .setSharePanel(invitationLink)
                }
            
        case .fetchFamilyMemebers:
            return inviteFamilyUseCase.executeFetchFamilyMembers()
                .withUnretained(self)
                .map {
                    let myMemberId: String? = $0.0.memberId
                    guard let familyResponse = $0.1?.results else {
                        return .injectFamilyMembers([])
                    }
                    
                    return .injectFamilyMembers(
                        familyResponse.map {
                            FamilyMemberProfileCellReactor(
                                $0, isMe: myMemberId == $0.memberId
                            )
                        }
                    )
                }
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setSharePanel(urlString):
            newState.familyInvitationUrl = URL(string: urlString)
            
        case .setCopySuccessToastMessageView:
            newState.shouldPresentCopySuccessToastMessageView = true
            
        case .setFetchFailureTaostMessageView:
            newState.shouldPresentFetchFailureToastMessageView = true
            
        case let .injectFamilyMembers(familyMembers):
            newState.displayMemberCount = familyMembers.count
            newState.displayFamilyMembers = [
                .init(model: Void(), items: familyMembers.sorted { $0.currentState.isMe && !$1.currentState.isMe })
            ]
        }
        return newState
    }
}
