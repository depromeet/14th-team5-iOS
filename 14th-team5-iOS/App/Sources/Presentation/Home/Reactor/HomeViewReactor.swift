//
//  HomeViewReactor.swift
//  App
//
//  Created by 마경미 on 05.12.23.
//

import Foundation
import Core
import Domain

import ReactorKit
import RxDataSources

public final class HomeViewReactor: Reactor {
    public enum Action {
        case viewDidLoad
        case getFamilyMembers
        case getTodayPostList
        case tapInviteFamily
    }
    
    public enum Mutation {
        case setFamilyResponse(FamilyResponse?)
        case setLoading(Bool)
        case setDidPost
        case setDescriptionText(String)
        case showShareAcitivityView(URL?)
        case showInviteFamilyView
        case showNoPostTodayView
        case setFamilyCollectionView([SectionModel<String, ProfileData>])
        case setPostCollectionView([SectionModel<String, PostListData>])
        case setCopySuccessToastMessageView
        case setFetchFailureToastMessageView
        case setSharePanel(String)
    }
    
    public struct State {
        var familyResponse: FamilyResponse?
        var familyInvitationLink: URL?
        var showLoading: Bool = true
        var didPost: Bool = false
        var descriptionText: String = HomeStrings.Description.standard
        var isShowingNoPostTodayView: Bool = false
        var isShowingInviteFamilyView: Bool = false
        var familySections: [SectionModel<String, ProfileData>] = []
        var feedSections: [SectionModel<String, PostListData>] = []
        @Pulse var shouldPresentCopySuccessToastMessageView: Bool = false
        @Pulse var shouldPresentFetchFailureToastMessageView: Bool = false
    }
    
    public let initialState: State = State()
    public let provider: GlobalStateProviderProtocol = GlobalStateProvider()
    private let familyRepository: SearchFamilyMemberUseCaseProtocol
    private let postRepository: PostListUseCaseProtocol
    private let familyUseCase: InviteFamilyViewUseCaseProtocol
    
    init(familyRepository: SearchFamilyMemberUseCaseProtocol, postRepository: PostListUseCaseProtocol, familyUseCase: InviteFamilyViewUseCaseProtocol) {
        self.familyUseCase = familyUseCase
        self.familyRepository = familyRepository
        self.postRepository = postRepository
    }
}

extension HomeViewReactor {
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
        case .viewDidLoad:
            guard App.Repository.member.familyId.value == nil else {
                return .empty()
            }
            
            return familyUseCase.executeCreateFamily()
                .map {
                    guard let familyResponse: FamilyResponse = $0 else {
                        return .setFamilyResponse(nil)
                    }
                    return .setFamilyResponse(familyResponse)
                }
                
        case .tapInviteFamily:
            return familyUseCase.executeFetchInvitationUrl()
                .map {
                    guard let invitationLink = $0?.url else {
                        return .setFetchFailureToastMessageView
                    }
                    return .setSharePanel(invitationLink)
                }
        case .getFamilyMembers:
            let query: SearchFamilyQuery = SearchFamilyQuery(type: "FAMILY", page: 1, size: 20)
            return familyRepository.excute(query: query)
                .asObservable()
                .flatMap { familyMembers in
                    guard let familyMembers else {
                        return Observable.just(Mutation.showInviteFamilyView)
                    }
                    if familyMembers.members.count == 1 {
                        return Observable.just(Mutation.showInviteFamilyView)
                    } else {
                        return Observable.just(.setFamilyCollectionView([
                            SectionModel<String, ProfileData>(model: "section1", items: familyMembers.members)
                        ]))
                    }
                }
        case .getTodayPostList:
            let query: PostListQuery = PostListQuery(page: 1, size: 20, date: Date().toFormatString(with: "YYYY-MM-DD"), memberId: "", sort: .desc)
            return postRepository.excute(query: query)
                .asObservable()
                .flatMap { postList in
                    guard let postList else {
                        return Observable.just(Mutation.showNoPostTodayView)
                    }
                    
                    if postList.postLists.isEmpty {
                        return Observable.just(Mutation.showNoPostTodayView)
                    }
                    
                    var observables = [Observable.just(Mutation.setPostCollectionView([
                        SectionModel<String, PostListData>(model: "section1", items: postList.postLists)]))]
                                                                                      
                    if postList.selfUploaded {
                        observables.append(Observable.just(Mutation.setDidPost))
                    }

                    if postList.allFamilyMembersUploaded {
                        observables.append(Observable.just(Mutation.setDescriptionText("우리 가족 모두가 사진을 올린 날🎉")))
                    }
                    
                    return Observable.concat(observables)
                }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
            //        case .setTimerStatus:
            //            newState.descriptionText = HomeStringLiterals.Description.standard
        case .showInviteFamilyView:
            newState.isShowingInviteFamilyView = true
        case let .setFamilyCollectionView(data):
            newState.familySections = data
        case .showNoPostTodayView:
            newState.isShowingNoPostTodayView = true
        case let .setPostCollectionView(data):
            newState.feedSections = data
        case let .showShareAcitivityView(url):
            newState.familyInvitationLink = url
        case .setDidPost:
            newState.didPost = true
        case .setDescriptionText(_):
            break
        case .setLoading:
            newState.showLoading = false
        case .setCopySuccessToastMessageView:
            newState.shouldPresentCopySuccessToastMessageView = true
        case .setFetchFailureToastMessageView:
            newState.shouldPresentFetchFailureToastMessageView = true
        case let .setSharePanel(urlString):
            newState.familyInvitationLink = URL(string: urlString)
        case let .setFamilyResponse(familyResponse):
            App.Repository.member.familyId.accept(familyResponse?.familyId)
            
            newState.familyResponse = familyResponse
        }
        
        return newState
    }
}
