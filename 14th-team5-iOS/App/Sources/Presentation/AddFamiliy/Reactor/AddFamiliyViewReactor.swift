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
        case presentToastMessage
        case refreshYourFamiliyMember([YourFamiliyMemeberProfile])
    }
    
    // MARK: - State
    public struct State {
        @Pulse var invitationUrl: URL?
        @Pulse var shouldPresentToastMessage: Bool = false
        var yourFamiliyDatasource: [SectionOfYourFamiliyMemberProfile] = []
    }
    
    // MARK: - Properties
    public let initialState: State
    public let provider: GlobalStateProviderType
    
    public let addFamiliyRepository: AddFamiliyImpl
    
    // MARK: - Intializer
    init(provider: GlobalStateProviderType) {
        self.initialState = State()
        self.provider = provider
        self.addFamiliyRepository = AddFamiliyRepository()
    }
    
    // MARK: - Transform
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = provider.activityGlobalState.event
            .flatMap { event -> Observable<Mutation> in
                switch event {
                case .didTapCopyInvitationUrlAction:
                    return Observable<Mutation>.just(.presentToastMessage)
                }
            }
        
        return Observable<Mutation>.merge(mutation, eventMutation)
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapInvitationUrlButton:
            // TODO: - FamilyID 구하는 코드 구현
//            return addFamiliyRepository.fetchInvitationUrl("01HGW2N7EHJVJ4CJ999RRS2E97")
//                .map { .presentSharePanel($0) }
            return Observable<Mutation>.just(.presentSharePanel(URL(string: "https://www.naver.com")))
        case .refreshYourFamiliyMemeber:
            return addFamiliyRepository.fetchFamiliyMemeber()
                .map {
                    let yourFamiliyMember = $0.map {
                        return YourFamiliyMemeberProfile(memberId: $0.memberId, name: $0.name, imageUrl: $0.imageUrl)
                    }
                    return .refreshYourFamiliyMember(yourFamiliyMember)
                }
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .presentSharePanel(url):
            newState.invitationUrl = url
        case .presentToastMessage:
            newState.shouldPresentToastMessage = true
        case let .refreshYourFamiliyMember(familiyMember):
            newState.yourFamiliyDatasource = [SectionOfYourFamiliyMemberProfile(items: familiyMember)]
        }
        return newState
    }
}
