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
        case updateRefreshEnd(Bool)
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
    @Injected var provider: ServiceProviderProtocol
    @Injected var postUseCase: FetchPostListUseCaseProtocol
    
    init(initialState: State) {
        self.initialState = initialState
    }
}

extension MainPostViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return Observable.concat([
                provider.mainService.refreshMain()
                    .flatMap { _ in Observable<Mutation>.empty() },
                self.mutate(action: .fetchPost)
                ])
        case .fetchPost:
            let query = PostListQuery(date: DateFormatter.dashYyyyMMdd.string(from: Date()), type: currentState.type)
            return postUseCase.execute(query: query)
                .asObservable()
                .flatMap { (postList) -> Observable<Mutation> in
                    guard let postList = postList,
                          !postList.isEmpty else {
                        return Observable.from([
                            Mutation.setNoPostTodayView(true),
                            Mutation.updateRefreshEnd(true),
                        ])
                    }
                    
                    let postSectionItem = postList.map(PostSection.Item.main)
                    let mutations = [
                        Mutation.updatePostDataSource(postSectionItem),
                        Mutation.setNoPostTodayView(false),
                        Mutation.updateRefreshEnd(true)
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
        case .setNoPostTodayView(let isShow):
            newState.isShowingNoPostTodayView = isShow
        case .updateRefreshEnd(let status):
            newState.isRefreshEnd = status
        }
        
        return newState
    }
}
