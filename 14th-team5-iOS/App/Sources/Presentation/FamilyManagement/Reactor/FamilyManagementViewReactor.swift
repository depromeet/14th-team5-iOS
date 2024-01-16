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

public final class FamilyManagementViewReactor: Reactor {
    // MARK: - Action
    public enum Action {
        case didTapShareButton
        case fetchFamilyMemebers
    }
    
    // MARK: - Mutate
    public enum Mutation {
        case setProgressView(Bool)
        case setSharePanel(String?)
        case setCopySuccessToastMessageView
        case setFetchFailureTaostMessageView
        case injectFamilyId(String?)
        case injectFamilyMembers([FamilyMemberProfileCellReactor])
    }
    
    // MARK: - State
    public struct State {
        var familyId: String?
        @Pulse var familyInvitationUrl: URL?
        @Pulse var shouldPresentCopySuccessToastMessageView: Bool
        @Pulse var shouldPresentFetchFailureToastMessageView: Bool
        @Pulse var displayFamilyMemberInfo: [FamilyMemberProfileSectionModel]
        var displayFamilyMemberCount: Int
        var shouldShowProgressView: Bool
    }
    
    // MARK: - Properties
    public let initialState: State
    
    public let familyUseCase: FamilyViewUseCaseProtocol
    public let provider: GlobalStateProviderProtocol
    
    private let memberId: String? = App.Repository.member.memberID.value
    
    // MARK: - Intializer
    init(
        familyUseCase: FamilyViewUseCaseProtocol,
        provider: GlobalStateProviderProtocol
    ) {
        self.initialState = State(
            familyId: nil,
            familyInvitationUrl: nil,
            shouldPresentCopySuccessToastMessageView: false,
            shouldPresentFetchFailureToastMessageView: false,
            displayFamilyMemberInfo: [],
            displayFamilyMemberCount: 0,
            shouldShowProgressView: false
        )
        
        self.familyUseCase = familyUseCase
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
            return Observable.concat(
                Observable<Mutation>.just(.setProgressView(true)),
                familyUseCase.executeFetchInvitationUrl()
                    .flatMap({
                        guard let invitationLink = $0?.url else {
                            return Observable<Mutation>.just(.setFetchFailureTaostMessageView)
                        }
                        return Observable<Mutation>.just(.setSharePanel(invitationLink))
                    }),
                Observable.just(.setProgressView(false))
            )
            
        case .fetchFamilyMemebers:
            return familyUseCase.executeFetchFamilyMembers()
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
        case let .setProgressView(hidden):
            newState.shouldShowProgressView = hidden
            
        case let .setSharePanel(urlString):
            newState.familyInvitationUrl = URL(string: urlString ?? "")
            
        case .setCopySuccessToastMessageView:
            newState.shouldPresentCopySuccessToastMessageView = true
            
        case .setFetchFailureTaostMessageView:
            newState.shouldPresentFetchFailureToastMessageView = true
            
        case let .injectFamilyId(familyId):
            newState.familyId = familyId
            
        case let .injectFamilyMembers(familyMembers):
            newState.displayFamilyMemberCount = familyMembers.count
            newState.displayFamilyMemberInfo = [
                .init(model: Void(), items: familyMembers.sorted { $0.currentState.isMe && !$1.currentState.isMe })
            ]
        }
        return newState
    }
}
