//
//  FamilyReactor.swift
//  App
//
//  Created by 마경미 on 20.04.24.
//

import Foundation

import Core
import Domain
import Util

import ReactorKit

final class MainFamilyViewReactor: Reactor {
    enum Action {
        case updateFamilySection([FamilySection.Item])
        case tapInviteFamily
    }
    
    enum Mutation {
//        case setSharePanel(String)
//        case showShareAcitivityView(URL?)
        
        case updateFamilyDataSource([FamilySection.Item])
        case setFetchFailureToastMessageView
        
        case setInviteFamilyView(Bool)
    }
    
    struct State {
//        @Pulse var familyInvitationLink: URL?
        @Pulse var shouldPresentFetchFailureToastMessageView: Bool = false
        @Pulse var familySection: FamilySection.Model = FamilySection.Model(model: 0, items: [])
        
        @Pulse var isShowingInviteFamilyView: Bool = false
    }
    
    let initialState: State = State()
    @Injected var provider: ServiceProviderProtocol
    @Injected var familyUseCase: FamilyUseCaseProtocol
    
    @Injected var fetchSharinUrlUseCase: FetchInvitationLinkUseCaseProtocol
    
    @Navigator var navigator: HomeNavigatorProtocol
}

extension MainFamilyViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tapInviteFamily:
            MPEvent.Home.shareLink.track(with: nil)
            return fetchSharinUrlUseCase.execute()
                .withUnretained(self)
                .flatMap {
                    guard let invitationLink = $0.1?.url else {
                        return Observable<Mutation>.just(.setFetchFailureToastMessageView)
                    }
                    $0.0.navigator.presentSharingSheet(url: URL(string: invitationLink))
                    return Observable<Mutation>.empty()
                }
        case .updateFamilySection(let items):
            if items.count < 2 {
                return Observable.from([.setInviteFamilyView(true)])
            } else{
                return Observable.from([.setInviteFamilyView(false), .updateFamilyDataSource(items)])
            }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
            case .updateFamilyDataSource(let familySectionItem):
                newState.familySection.items = familySectionItem
            case .setInviteFamilyView(let isShow):
                newState.isShowingInviteFamilyView = isShow
//            case let .showShareAcitivityView(url):
//                newState.familyInvitationLink = url
            case .setFetchFailureToastMessageView:
                newState.shouldPresentFetchFailureToastMessageView = true
//            case let .setSharePanel(urlString):
//                newState.familyInvitationLink = URL(string: urlString)
        }
        
        return newState
    }
}
