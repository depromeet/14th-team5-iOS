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
        case getTodayPostList
        case refreshCollectionview
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case setDidPost
        case setDescriptionText(String)
        case showNoPostTodayView
        case setPostCollectionView([SectionModel<String, PostListData>])
        case setRefreshing(Bool)
    }
    
    public struct State {
        var isRefreshing: Bool = false
        var showLoading: Bool = true
        var didPost: Bool = false
        var descriptionText: String = HomeStrings.Description.standard
        var isShowingNoPostTodayView: Bool = false
        var feedSections: [SectionModel<String, PostListData>] = []
    }
    
    public let initialState: State = State()
    private let postRepository: PostListUseCaseProtocol
    
    init(postRepository: PostListUseCaseProtocol) {
        self.postRepository = postRepository
    }
}

extension HomeViewReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .getTodayPostList:
            let query: PostListQuery = PostListQuery(page: 1, size: 20, date: Date().toFormatString(with: "YYYY-MM-DD"), memberId: "", sort: .desc)
            return postRepository.excute(query: query)
                .asObservable()
                .flatMap { postList in
                    guard let postList,
                          !postList.postLists.isEmpty else {
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
                    
                    observables.append(Observable.just(Mutation.setRefreshing(false)))
                    return Observable.concat(observables)
                }
        case .refreshCollectionview:
            let getTodayPostListAction = Action.getTodayPostList
            return mutate(action: getTodayPostListAction)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .showNoPostTodayView:
            newState.isShowingNoPostTodayView = true
        case let .setPostCollectionView(data):
            newState.feedSections = data
        case .setDidPost:
            newState.didPost = true
        case let .setDescriptionText(message):
            newState.descriptionText = message
        case .setLoading:
            newState.showLoading = false
        case let .setRefreshing(isRefreshing):
            newState.isRefreshing = isRefreshing
        }
        
        return newState
    }
}
