//
//  HomeFamilyViewReactor.swift
//  App
//
//  Created by 마경미 on 13.01.24.
//

import Foundation

import Core
import Domain

import ReactorKit
import RxDataSources

public final class HomeFamilyViewReactor: Reactor {
    public enum Action {
        case getFamilyMembers
        case tapInviteFamily
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case showShareAcitivityView(URL?)
        case showInviteFamilyView
        case setFamilyCollectionView([SectionModel<String, ProfileData>])
        case setCopySuccessToastMessageView
        case setFetchFailureToastMessageView
        case setSharePanel(String)
    }
    
    public struct State {
        var showLoading: Bool = true
        var isShowingInviteFamilyView: Bool = false
        var familySections: [SectionModel<String, ProfileData>] = []
        @Pulse var familyInvitationLink: URL?
        @Pulse var shouldPresentCopySuccessToastMessageView: Bool = false
        @Pulse var shouldPresentFetchFailureToastMessageView: Bool = false
    }
    
    public let initialState: State = State()
    public let provider: GlobalStateProviderProtocol = GlobalStateProvider()
    private let searchFamilyUseCase: SearchFamilyMemberUseCaseProtocol
    private let inviteFamilyUseCase: FamilyViewUseCaseProtocol
    
    init(searchFamilyUseCase: SearchFamilyMemberUseCaseProtocol, inviteFamilyUseCase: FamilyViewUseCaseProtocol) {
        self.inviteFamilyUseCase = inviteFamilyUseCase
        self.searchFamilyUseCase = searchFamilyUseCase
    }
}

extension HomeFamilyViewReactor {
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
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tapInviteFamily:
            return inviteFamilyUseCase.executeFetchInvitationUrl()
                .map {
                    guard let invitationLink = $0?.url else {
                        return .setFetchFailureToastMessageView
                    }
                    return .setSharePanel(invitationLink)
                }
        case .getFamilyMembers:
            let query: SearchFamilyQuery = SearchFamilyQuery(type: "FAMILY", page: 1, size: 20)
            return searchFamilyUseCase.excute(query: query)
                .asObservable()
                .flatMap { familyMembers in
                    guard let familyMembers,
                          familyMembers.members.count > 1 else {
                        return Observable.just(Mutation.showInviteFamilyView)
                    }
                    
                    var observables = [Observable.just(Mutation.setFamilyCollectionView([
                        SectionModel<String, ProfileData>(model: "section1", items: familyMembers.members)]))]
        
                    return Observable.concat(observables)
                }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .showInviteFamilyView:
            newState.isShowingInviteFamilyView = true
        case let .setFamilyCollectionView(data):
            newState.familySections = data
        case let .showShareAcitivityView(url):
            newState.familyInvitationLink = url
        case .setLoading:
            newState.showLoading = false
        case .setCopySuccessToastMessageView:
            newState.shouldPresentCopySuccessToastMessageView = true
        case .setFetchFailureToastMessageView:
            newState.shouldPresentFetchFailureToastMessageView = true
        case let .setSharePanel(urlString):
            newState.familyInvitationLink = URL(string: urlString)
        }
        
        return newState
    }
}
