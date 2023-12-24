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
        case refreshYourFamilyMemeber
    }
    
    // MARK: - Mutate
    public enum Mutation {
        case presentSharePanel(URL?)
        case presentInvitationUrlCopySuccessToastMessage
        case presentFetchInvitationUrlFailureTaostMessage
        case refreshYourFamilyMember(SectionOfFamilyMemberProfile)
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
    
    public let addFamiliyRepository: FamilyImpl
    
    // MARK: - Intializer
    init(provider: GlobalStateProviderType) {
        self.initialState = State()
        self.provider = provider
<<<<<<< HEAD:14th-team5-iOS/App/Sources/Presentation/AddFamiliy/Reactor/AddFamilyViewReactor.swift
        self.addFamiliyRepository = FamiliyRepository()
=======
        
        self.addFamilyRepository = AddFamilyRepository()
>>>>>>> 544612a (feat: FamilyMemeber 모델 수정 (#100)):14th-team5-iOS/App/Sources/Presentation/AddFamily/Reactor/AddFamilyViewReactor.swift
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
            // TODO: - 통신 성공 여부 확인
            return addFamiliyRepository.fetchInvitationUrl()
                .map {
                    guard let url = $0 else {
                        return .presentFetchInvitationUrlFailureTaostMessage
                    }
                    return .presentSharePanel(url)
                }
        case .refreshYourFamilyMemeber:
            // TODO: - 통신 성공 여부 확인
            return addFamiliyRepository.fetchFamiliyMemeber()
                .map {
                    guard let paginationFamilyMember = $0 else {
                        return .refreshYourFamilyMember(.init(items: []))
                    }
                    return .refreshYourFamilyMember(.init(items: paginationFamilyMember.results))
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
        case let .refreshYourFamilyMember(familiyMember):
            newState.familyDatasource = [familiyMember]
            newState.familyMemberCount = familiyMember.items.count
        }
        return newState
    }
}
