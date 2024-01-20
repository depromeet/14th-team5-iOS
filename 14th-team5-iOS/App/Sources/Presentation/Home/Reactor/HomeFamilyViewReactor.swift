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
import Kingfisher

final class HomeFamilyViewReactor: Reactor {
    enum Action {
        case viewWillAppear
        case prefetchItems([FamilySection.Item])
        case tapInviteFamily
        case pagination(
            contentHeight: CGFloat,
            contentOffsetY: CGFloat,
            scrollViewHeight: CGFloat
        )
    }
    
    enum Mutation {
        case setLoading(Bool)
        case showShareAcitivityView(URL?)
        case showInviteFamilyView
        case setCopySuccessToastMessageView
        case setFetchFailureToastMessageView
        case setSharePanel(String)
        case initDataSource([FamilySection.Item])
        case updateDataSource([FamilySection.Item])
    }
    
    public struct State {
        var showLoading: Bool = true
        var isShowingInviteFamilyView: Bool = false
        var familySections = FamilySection.Model(
            model: 0,
            items: []
        )
        
        @Pulse var familyInvitationLink: URL?
        @Pulse var shouldPresentCopySuccessToastMessageView: Bool = false
        @Pulse var shouldPresentFetchFailureToastMessageView: Bool = false
    }
    
    public let initialState: State = State()
    public let provider: GlobalStateProviderProtocol = GlobalStateProvider()
    private let searchFamilyUseCase: SearchFamilyMemberUseCaseProtocol
    private let inviteFamilyUseCase: FamilyViewUseCaseProtocol
    
    private var currentPage: Int = 0
    private var isLast: Bool = false
    
    init(searchFamilyUseCase: SearchFamilyMemberUseCaseProtocol, inviteFamilyUseCase: FamilyViewUseCaseProtocol) {
        self.inviteFamilyUseCase = inviteFamilyUseCase
        self.searchFamilyUseCase = searchFamilyUseCase
    }
}

extension HomeFamilyViewReactor {
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = provider.activityGlobalState.event
            .flatMap { event -> Observable<Mutation> in
                switch event {
                case .didTapCopyInvitationUrlAction:
                    return Observable<Mutation>.just(.setCopySuccessToastMessageView)
                default:
                    return Observable<Mutation>.empty()
                }
            }
        
        return Observable<Mutation>.merge(mutation, eventMutation)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            currentPage = 1
            isLast = false
            
            let query = SearchFamilyQuery(page: currentPage, size: 10)
            return searchFamilyUseCase.excute(query: query)
                .asObservable()
                .flatMap { familyMembers in
                    guard let familyMembers,
                          familyMembers.members.count > 1 else {
                        return Observable.just(Mutation.showInviteFamilyView)
                    }
                    
                    let familySectionItem = familyMembers.members.map(FamilySection.Item.main)
                    return Observable.concat([
                        //                        Observable.just(Mutation.show)
                        Observable.just(Mutation.initDataSource(familySectionItem))
                    ])
                }
        case .tapInviteFamily:
            return inviteFamilyUseCase.executeFetchInvitationUrl()
                .map {
                    guard let invitationLink = $0?.url else {
                        return .setFetchFailureToastMessageView
                    }
                    return .setSharePanel(invitationLink)
                }
        case let .pagination(contentHeight, contentOffsetY, scrollViewHeight):
            let paddingSpace = contentHeight - contentOffsetY
            if paddingSpace < scrollViewHeight {
                return getFamilyMembers()
            } else {
                return .empty()
            }
        case let .prefetchItems(items):
            var urls = [URL]()
            items.forEach {
                if case let .main(profile) = $0,
                   let imageURL = profile.profileImageURL,
                   let url = URL(string: imageURL) {
                    urls.append(url)
                }
            }
            ImagePrefetcher(resources: urls).start()
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .showInviteFamilyView:
            newState.isShowingInviteFamilyView = true
        case let .updateDataSource(sectionItem):
            newState.familySections.items.append(contentsOf: sectionItem)
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
        case let .initDataSource(sectionItem):
            newState.familySections.items = sectionItem
        }
        
        return newState
    }
}

extension HomeFamilyViewReactor {
    private func getFamilyMembers() -> Observable<Mutation> {
        self.currentPage += 1
        
        guard !isLast else {
            return Observable.empty()
        }
        
        let query: SearchFamilyQuery = SearchFamilyQuery(page: currentPage, size: 10)
        return searchFamilyUseCase.excute(query: query)
            .asObservable()
            .flatMap { familyMembers -> Observable<Mutation> in
                guard let familyMembers else {
                    return Observable.empty()
                }
                
                self.isLast = true
                
                let familySectionItem = familyMembers.members.map(FamilySection.Item.main)
                return Observable.just(Mutation.updateDataSource(familySectionItem))
            }
    }
}
