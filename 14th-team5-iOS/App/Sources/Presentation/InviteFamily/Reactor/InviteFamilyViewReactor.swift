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

public final class InviteFamilyViewReactor: Reactor {
    // MARK: - Action
    public enum Action {
        case didTapShareButton
        case fetchFamilyMemebers
    }
    
    // MARK: - Mutate
    public enum Mutation {
        case makeSharePanel(String)
        case makeShareSuccessToastMessageView
        case makeShareFailureTaostMessageView
        case injectFamilyMembers(SectionOfFamilyMemberProfile)
    }
    
    // MARK: - State
    public struct State {
        @Pulse var invitationLink: String = ""
        @Pulse var copySuccessToastMessageView: Bool = false
        @Pulse var copyFailureToastMessageView: Bool = false
        var familyDatasource: [SectionOfFamilyMemberProfile] = [.init(items: [])]
    }
    
    // MARK: - Properties
    public let initialState: State
    
    public let inviteFamilyUseCase: InviteFamilyViewUseCaseProtocol
    public let provider: GlobalStateProviderProtocol
    
    // MARK: - Intializer
    init(usecase: InviteFamilyViewUseCaseProtocol, provider: GlobalStateProviderProtocol) {
        self.initialState = State()
        
        self.inviteFamilyUseCase = usecase
        self.provider = provider
    }
    
    // MARK: - Transform
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = provider.activityGlobalState.event
            .flatMap { event -> Observable<Mutation> in
                switch event {
                case .didTapCopyInvitationUrlAction:
                    return Observable<Mutation>.just(.makeShareSuccessToastMessageView)
                }
            }
        
        return Observable<Mutation>.merge(mutation, eventMutation)
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapShareButton:
            return inviteFamilyUseCase.executeFetchInvitationUrl()
                .flatMap {
                    guard let invitationLinkResponse = $0 else {
                        return Observable<Mutation>.just(.makeShareFailureTaostMessageView)
                    }
                    return Observable<Mutation>.just(.makeSharePanel(invitationLinkResponse.url))
                }
            
            // NOTE: - 테스트 코드
//            return Observable<Mutation>.just(
//                .presentSharePanel(URL(string: "https://www.naver.com"))
//            )
            
        case .fetchFamilyMemebers:
            return inviteFamilyUseCase.executeFetchFamilyMembers()
                .map {
                    guard let paginationFamilyMember = $0 else {
                        return .injectFamilyMembers(.init(items: []))
                    }
                    return .injectFamilyMembers(.init(items: paginationFamilyMember.results))
                }
            
            // NOTE: - 테스트 코드
//            return Observable<Mutation>.just(
//                .fetchYourFamilyMember(SectionOfFamilyMemberProfile.generateTestData())
//            )
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .makeSharePanel(urlString):
            newState.invitationLink = urlString
            
        case .makeShareSuccessToastMessageView:
            newState.copySuccessToastMessageView = true
            
        case .makeShareFailureTaostMessageView:
            newState.copyFailureToastMessageView = true
            
        case let .injectFamilyMembers(familyMember):
            print("불러온 패밀리 멤버: ")
            print(familyMember)
            newState.familyDatasource = [familyMember]
        }
        return newState
    }
}
