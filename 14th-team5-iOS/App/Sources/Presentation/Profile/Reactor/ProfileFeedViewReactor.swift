//
//  ProfileFeedViewReactor.swift
//  App
//
//  Created by Kim dohyun on 5/4/24.
//

import Foundation

import Core
import Domain
import RxSwift
import RxCocoa
import ReactorKit

final class ProfileFeedViewReactor: Reactor {
    var initialState: State
    private let feedUseCase: ProfileFeedUseCaseProtocol
    
    enum Action {
        case reloadFeedItems
        case fetchMoreFeedItems
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setFeedSectionItems([ProfileFeedSectionItem])
        case setFeedItemPage(Int)
        case setFeedPaginationItems([PostListData])
        case setFeedItems(PostListPage)
    }
    
    struct State {
        var isLoading: Bool
        var memberId: String
        @Pulse var feedPaginationItems: [PostListData]
        @Pulse var feedPage: Int
        @Pulse var type: PostType
        @Pulse var feedItems: PostListPage?
        @Pulse var feedSection: [ProfileFeedSectionModel]
    }
    
    init(feedUseCase: ProfileFeedUseCaseProtocol, type: PostType, memberId: String) {
        self.feedUseCase = feedUseCase
        self.initialState = State(
            isLoading: false,
            memberId: memberId,
            feedPaginationItems: [],
            feedPage: 1,
            type: type,
            feedItems: nil,
            feedSection: [.feedCategory([])]
        )
    }
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        var query: PostListQuery = PostListQuery(page: currentState.feedPage, size: 10, date: "", memberId: currentState.memberId, type: currentState.type, sort: .desc)
        
        switch action {
        case .reloadFeedItems:
            return feedUseCase.execute(query: query)
                .asObservable()
                .flatMap { entity -> Observable<ProfileFeedViewReactor.Mutation> in
                    var sectionItem: [ProfileFeedSectionItem] = []
                    guard let entity = entity else { return .empty() }
                    
                    if entity.postLists.isEmpty {
                        sectionItem.append(
                            .feedCateogryEmptyItem(
                                ProfileFeedEmptyCellReactor(
                                    descrption: "아직 업로드한 사진이 없어요",
                                    resource: "profileEmpty"
                                )
                            )
                        )
                    } else {
                        entity.postLists.forEach {
                            sectionItem.append(
                                .feedCategoryItem(
                                    ProfileFeedCellReactor(
                                        imageURL: URL(string: $0.imageURL) ?? URL(fileReferenceLiteralResourceName: ""),
                                        emojiCount: "\($0.emojiCount)",
                                        date: $0.time,
                                        commentCount: "\($0.commentCount)",
                                        content: $0.content?.map { "\($0)"} ?? [],
                                        feedType: $0.missionType ?? .none
                                    )
                                )
                            )
                        }
                    }
                    return .concat(
                        .just(.setLoading(false)),
                        .just(.setFeedPaginationItems(entity.postLists)),
                        .just(.setFeedItems(entity)),
                        .just(.setFeedSectionItems(sectionItem)),
                        .just(.setLoading(true))
                    )
                }
        case .fetchMoreFeedItems:
            print("query page: \(query.page)")
            let updatePage = currentState.feedPage + 1
            query.page = updatePage
            print("fetch query value: \(query.page)")
            return feedUseCase.execute(query: query)
                .asObservable()
                .withUnretained(self)
                .flatMap { owner, entity -> Observable<ProfileFeedViewReactor.Mutation> in
                    var sectionItem: [ProfileFeedSectionItem] = []
                    guard let entity = entity else { return .empty() }
                    
                    var feedItems: [PostListData] = owner.currentState.feedPaginationItems
                    feedItems.append(contentsOf: entity.postLists)
                    
                    feedItems.forEach {
                        sectionItem.append(
                            .feedCategoryItem(
                                ProfileFeedCellReactor(
                                    imageURL: URL(string: $0.imageURL) ?? URL(fileReferenceLiteralResourceName: ""),
                                    emojiCount: "\($0.emojiCount)",
                                    date: $0.time,
                                    commentCount: "\($0.commentCount)",
                                    content: $0.content?.map { "\($0)"} ?? [],
                                    feedType: $0.missionType ?? .none
                                )
                            )
                        )
                    }
                    
                    return .concat(
                        .just(.setLoading(false)),
                        .just(.setFeedItemPage(updatePage)),
                        .just(.setFeedPaginationItems(feedItems)),
                        .just(.setFeedSectionItems(sectionItem)),
                        .just(.setLoading(true))
                    )
                }
        }
    }
    

    
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        case let .setFeedItems(feedItems):
            newState.feedItems = feedItems
        case let .setFeedSectionItems(section):
            let sectionIndex = getSection(.feedCategory([]))
            newState.feedSection[sectionIndex] = .feedCategory(section)
        case let .setFeedItemPage(feedPage):
            newState.feedPage = feedPage
        case let .setFeedPaginationItems(PaginationItems):
            newState.feedPaginationItems = PaginationItems
        }
        
        return newState
    }
    
}


extension ProfileFeedViewReactor {
    func getSection(_ section: ProfileFeedSectionModel) -> Int {
        var index: Int = 0
        
        for i in 0 ..< self.currentState.feedSection.count where self.currentState.feedSection[i].getSectionType() == section.getSectionType() {
            index = i
        }
        
        return index
    }
}
