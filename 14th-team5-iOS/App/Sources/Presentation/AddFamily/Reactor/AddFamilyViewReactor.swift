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
import ReactorKit
import RxSwift

public final class AddFamilyViewReactor: Reactor {
    // MARK: - Action
    public enum Action {
        case didTapInvitationUrlButton
        case fetchYourFamilyMemeber
    }
    
    // MARK: - Mutate
    public enum Mutation {
        case presentSharePanel(URL?)
        case presentInvitationUrlCopySuccessToastMessage
        case presentFetchInvitationUrlFailureTaostMessage
        case fetchYourFamilyMember(SectionOfFamilyMemberProfile)
    }
    
    // MARK: - State
    public struct State {
        @Pulse var invitationUrl: URL?
        @Pulse var shouldPresentInvitationUrlCopySuccessToastMessage: Bool = false
        @Pulse var shouldPresentFetchInvitationUrlFailureToastMessage: Bool = false
        var familyMemberCount: Int = 0
        var familyDatasource: [SectionOfFamilyMemberProfile] = [.init(items: [])]
    }
    
    // MARK: - Properties
    public let initialState: State
    public let provider: GlobalStateProviderType
    
    public let addFamilyRepository: FamilyImpl
    
    // MARK: - Intializer
    init(provider: GlobalStateProviderType) {
        self.initialState = State()
        self.provider = provider
        
        self.addFamilyRepository = FamilyRepository()
    }
    
    // MARK: - Transform
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = provider.activityGlobalState.event
            .flatMap { event -> Observable<Mutation> in
                switch event {
                case .didTapCopyInvitationUrlAction:
                    return Observable<Mutation>.just(.presentInvitationUrlCopySuccessToastMessage)
                }
            }
        
        return Observable<Mutation>.merge(mutation, eventMutation)
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapInvitationUrlButton:
//            return addFamilyRepository.fetchInvitationUrl()
//                .map {
//                    guard let url = $0 else {
//                        return .presentFetchInvitationUrlFailureTaostMessage
//                    }
//                    return .presentSharePanel(url)
//                }
            
            // NOTE: - 테스트 코드
            return Observable<Mutation>.just(
                .presentSharePanel(URL(string: "https://www.naver.com"))
            )
            
        case .fetchYourFamilyMemeber:
//            return addFamilyRepository.fetchFamilyMemeber()
//                .map {
//                    guard let paginationFamilyMember = $0 else {
//                        return .fetchYourFamilyMember(.init(items: []))
//                    }
//                    return .fetchYourFamilyMember(.init(items: paginationFamilyMember.results))
//                }
            
            // NOTE: - 테스트 코드
            return Observable<Mutation>.just(
                .fetchYourFamilyMember(SectionOfFamilyMemberProfile.generateTestData())
            )
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .presentSharePanel(url):
            newState.invitationUrl = url
        case .presentInvitationUrlCopySuccessToastMessage:
            newState.shouldPresentInvitationUrlCopySuccessToastMessage = true
        case .presentFetchInvitationUrlFailureTaostMessage:
            newState.shouldPresentFetchInvitationUrlFailureToastMessage = true
        case let .fetchYourFamilyMember(familiyMember):
            newState.familyDatasource = [familiyMember]
            newState.familyMemberCount = familiyMember.items.count
        }
        return newState
    }
}
