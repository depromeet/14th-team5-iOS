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
    @Injected private var feedUseCase: FetchPostListUseCaseProtocol
    @Injected private var provider: ServiceProviderProtocol
    enum Action {
        case reloadFeedItems
        case fetchMoreFeedItems
        case didTapProfileFeedItem(IndexPath, [PostEntity])
    }
    
    enum Mutation {
        case setFeedSectionItems([ProfileFeedSectionItem])
        case setFeedItemPage(Int)
        case setFeedPaginationItems([PostEntity])
        case setFeedItems(PostListPageEntity)
        case setFeedDetailItem(PostSection.Model, IndexPath)
    }
    
    struct State {
        var memberId: String
        @Pulse var selectedIndex: IndexPath?
        @Pulse var feedDetailItem: PostSection.Model
        @Pulse var feedPaginationItems: [PostEntity]
        @Pulse var feedPage: Int
        @Pulse var type: PostType
        @Pulse var feedItems: PostListPageEntity?
        @Pulse var feedSection: [ProfileFeedSectionModel]
    }
    
    init(
        type: PostType,
        memberId: String
    ) {
        self.initialState = State(
            memberId: memberId,
            selectedIndex: nil,
            feedDetailItem: .init(model: 0, items: []),
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
                                        date: $0.time.toDate(with: "yyyy-MM-dd'T'HH:mm:ssZ").relativeFormatter(),
                                        commentCount: "\($0.commentCount)",
                                        content: $0.content?.map { "\($0)"} ?? [],
                                        feedType: $0.missionType ?? .none
                                    )
                                )
                            )
                        }
                    }
                    return .concat(
                        .just(.setFeedPaginationItems(entity.postLists)),
                        .just(.setFeedItems(entity)),
                        .just(.setFeedSectionItems(sectionItem))
                    )
                }
        case .fetchMoreFeedItems:
            let updatePage = currentState.feedPage + 1
            query.page = updatePage
            return feedUseCase.execute(query: query)
                .asObservable()
                .withUnretained(self)
                .flatMap { owner, entity -> Observable<ProfileFeedViewReactor.Mutation> in
                    var sectionItem: [ProfileFeedSectionItem] = []
                    guard let entity = entity else { return .empty() }
                    
                    var feedItems: [PostEntity] = owner.currentState.feedPaginationItems
                    feedItems.append(contentsOf: entity.postLists)
                    
                    feedItems.forEach {
                        sectionItem.append(
                            .feedCategoryItem(
                                ProfileFeedCellReactor(
                                    imageURL: URL(string: $0.imageURL) ?? URL(fileReferenceLiteralResourceName: ""),
                                    emojiCount: "\($0.emojiCount)",
                                    date: $0.time.toDate(with: "yyyy-MM-dd'T'HH:mm:ssZ").relativeFormatter(),
                                    commentCount: "\($0.commentCount)",
                                    content: $0.content?.map { "\($0)"} ?? [],
                                    feedType: $0.missionType ?? .none
                                )
                            )
                        )
                    }
                    
                    return .concat(
                        .just(.setFeedPaginationItems(feedItems)),
                        .just(.setFeedItemPage(updatePage)),
                        .just(.setFeedSectionItems(sectionItem))
                    )
                }
        case let .didTapProfileFeedItem(indexPath, feedItems):
            var feedDetailSection: PostSection.Model = .init(model: 0, items: [])
            
            feedItems.forEach {
                feedDetailSection.items.append(
                    .main(PostEntity(
                        postId: $0.postId,
                        missionId: $0.missionId,
                        missionType: $0.missionType,
                        author: FamilyMemberProfileEntity(
                            memberId: currentState.memberId,
                            profileImageURL: $0.author.profileImageURL,
                            name: $0.author.name),
                        commentCount: $0.commentCount,
                        emojiCount: $0.emojiCount,
                        imageURL: $0.imageURL,
                        content: $0.content,
                        time: $0.time
                    )
                    )
                )
            }
            
            
            return .just(.setFeedDetailItem(feedDetailSection, indexPath))
        }
    }
    

    
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setFeedItems(feedItems):
            newState.feedItems = feedItems
        case let .setFeedSectionItems(section):
            let sectionIndex = getSection(.feedCategory([]))
            newState.feedSection[sectionIndex] = .feedCategory(section)
        case let .setFeedItemPage(feedPage):
            newState.feedPage = feedPage
        case let .setFeedPaginationItems(PaginationItems):
            newState.feedPaginationItems = PaginationItems
        case let .setFeedDetailItem(feedDetailItem, selectedIndex):
            newState.feedDetailItem = feedDetailItem
            newState.selectedIndex = selectedIndex
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
