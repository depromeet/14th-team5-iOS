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

public final class AddFamiliyViewReactor: Reactor {
    // MARK: - Action
    public enum Action {
        case didTapInvitationUrlButton
        case refreshYourFamiliyMemeber
    }
    
    // MARK: - Mutate
    public enum Mutation {
        case presentSharePanel(URL?)
        case presentInvitationUrlCopySuccessToastMessage
        case presentFetchInvitationUrlFailureTaostMessage
        case refreshYourFamiliyMember([SectionOfFamiliyMemberProfile])
    }
    
    // MARK: - State
    public struct State {
        @Pulse var invitationUrl: URL?
        @Pulse var shouldPresentInvitationUrlCopySuccessToastMessage: Bool = false
        @Pulse var shouldPresentFetchInvitationUrlFailureToastMessage: Bool = false
        var yourFamiliyDatasource: [SectionOfFamiliyMemberProfile] = []
        var yourFaimliyMemberCount: Int = 0
    }
    
    // MARK: - Properties
    public let initialState: State
    public let provider: GlobalStateProviderType
    
    public let addFamiliyRepository: FamiliyImpl
    
    // MARK: - Intializer
    init(provider: GlobalStateProviderType) {
        self.initialState = State()
        self.provider = provider
        self.addFamiliyRepository = FamiliyRepository()
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
            // TODO: - 통신 성공 여부 확인, FamilyID 구하는 코드 구현
            return addFamiliyRepository.fetchInvitationUrl("01HGW2N7EHJVJ4CJ999RRS2E97")
                .map {
                    guard let url = $0 else {
                        return .presentFetchInvitationUrlFailureTaostMessage
                    }
                    return .presentSharePanel(url)
                }
        case .refreshYourFamiliyMemeber:
            // TODO: - 통신 성공 여부 확인
            return addFamiliyRepository.fetchFamiliyMemeber()
                .map {
                    guard let familiyMember = $0 else {
                        return .refreshYourFamiliyMember([])
                    }
                    let sectionModel = SectionOfFamiliyMemberProfile.toSectionModel(familiyMember)
                    return .refreshYourFamiliyMember(sectionModel)
                }
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
        case let .refreshYourFamiliyMember(familiyMember):
            newState.yourFamiliyDatasource = familiyMember
            newState.yourFaimliyMemberCount = familiyMember.first?.items.count ?? 0
        }
        return newState
    }
}
