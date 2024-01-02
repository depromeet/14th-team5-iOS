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
        case getFamilyMembers
        case getTodayPostList
        case tapInviteFamily
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case setDidPost
        case setDescriptionText(String)
        case showShareAcitivityView(URL?)
        case showInviteFamilyView
        case showNoPostTodayView
        case setFamilyCollectionView([SectionModel<String, ProfileData>])
        case setPostCollectionView([SectionModel<String, PostListData>])
    }
    
    public struct State {
        var inviteLink: URL?
        var showLoading: Bool = true
        var didPost: Bool = false
        var descriptionText: String = HomeStrings.Description.standard
        var isShowingNoPostTodayView: Bool = false
        var isShowingInviteFamilyView: Bool = false
        var familySections: [SectionModel<String, ProfileData>] = []
        var feedSections: [SectionModel<String, PostListData>] = []
    }
    
    public let initialState: State = State()
    public let provider: GlobalStateProviderProtocol = GlobalStateProvider()
    private let familyRepository: SearchFamilyMemberUseCaseProtocol
    private let postRepository: PostListUseCaseProtocol
    
    init(familyRepository: SearchFamilyMemberUseCaseProtocol, postRepository: PostListUseCaseProtocol) {
        self.familyRepository = familyRepository
        self.postRepository = postRepository
    }
}

extension HomeViewReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tapInviteFamily:
            return Observable.concat(
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.showShareAcitivityView(URL(string: "https://github.com/depromeet/14th-team5-iOS"))),
                Observable.just(Mutation.setLoading(false))
            )
        case .getFamilyMembers:
            let query: SearchFamilyQuery = SearchFamilyQuery(type: "FAMILY", page: 1, size: 20)
            return familyRepository.excute(query: query)
                .asObservable()
                .debug("family")
                .flatMap { familyMembers in
//                    Observable.just(Mutation.setLoading(false))
                    guard let familyMembers else {
                        return Observable.just(Mutation.showInviteFamilyView)
                    }
                    if familyMembers.members.isEmpty {
                        return Observable.just(Mutation.showInviteFamilyView)
                    } else {
                        return Observable.just(.setFamilyCollectionView([
                            SectionModel<String, ProfileData>(model: "section1", items: familyMembers.members)
                        ]))
                    }
                }
        case .getTodayPostList:
            let query: PostListQuery = PostListQuery(page: 1, size: 20, date: "2023-12-05", memberId: "", sort: .desc)
            return postRepository.excute(query: query)
                .asObservable()
                .debug("postlist")
                .flatMap { postList in
//                    Observable.just(Mutation.setLoading(false)) // Loading 완료 시점
                    guard let postList else {
                        return Observable.just(Mutation.showNoPostTodayView)
                    }
                    
                    if postList.postLists.isEmpty {
                        return Observable.just(Mutation.showNoPostTodayView)
                    }
                    
                    // 내꺼 멤버 아이디 넣기
                    if postList.checkAuthor(authorId: "") {
                        return Observable.just(Mutation.setDidPost)
                    }
                    
                    return Observable.just(Mutation.setPostCollectionView([
                        SectionModel<String, PostListData>(model: "section1", items: postList.postLists)
                    ]))
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
            newState.inviteLink = url
        case .setDidPost:
            newState.didPost = true
        case .setDescriptionText(_):
            break
        case .setLoading:
            newState.showLoading = false
        }
        
        return newState
    }
}
