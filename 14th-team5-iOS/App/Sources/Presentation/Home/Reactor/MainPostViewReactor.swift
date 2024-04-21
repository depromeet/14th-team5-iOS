//
//  FeedViewReactor.swift
//  App
//
//  Created by 마경미 on 13.02.24.
//

import Foundation

import Core
import Domain

import ReactorKit
import RxDataSources

final class MainPostViewReactor: Reactor {
    enum Action {
        case fetchPost
        case refresh
    }
    
    enum Mutation {
        case setNoPostTodayView(Bool)
        case updatePostDataSource([PostSection.Item])
    }
    
    struct State {
        let type: PostType
        
        @Pulse var isRefreshEnd: Bool = true
        @Pulse var postSection: PostSection.Model = PostSection.Model(model: 0, items: [])
        var isShowingNoPostTodayView: Bool = false
    }
    
    let initialState: State
    private let postUseCase: PostListUseCaseProtocol
    
    init(initialState: State, postUseCase: PostListUseCaseProtocol) {
        self.initialState = initialState
        self.postUseCase = postUseCase
    }
}

extension MainPostViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return self.mutate(action: .fetchPost)
        case .fetchPost:
            let query = PostListQuery(date: DateFormatter.dashYyyyMMdd.string(from: Date()), type: currentState.type)
            return postUseCase.excute(query: query)
                .asObservable()
                .flatMap { (postList) -> Observable<Mutation> in
                    guard let postList = postList,
                          !postList.postLists.isEmpty else {
                        return Observable.from([Mutation.setNoPostTodayView(true)])
                    }
    
                    let postSectionItem = postList.postLists.map(PostSection.Item.main)
                    let mutations = [
                        Mutation.updatePostDataSource(postSectionItem),
                        Mutation.setNoPostTodayView(false)
                    ]
                    
                    return Observable.from(mutations)
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .updatePostDataSource(let postSectionItem):
            newState.isRefreshEnd = true
            newState.postSection.items = postSectionItem
            App.Repository.member.postId.accept(UserDefaults.standard.postId)
        case .setNoPostTodayView(let isShow):
            newState.isShowingNoPostTodayView = isShow
        }
        
        return newState
    }
}
