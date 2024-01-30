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
import Kingfisher

final class HomeViewReactor: Reactor {
    enum Action {
        case viewWillAppear
    }
    
    enum Mutation {
        case setSelfUploaded(Bool)
        case setAllFamilyUploaded(Bool)
        case setInviteFamilyView(Bool)
        case setNoPostTodayView(Bool)
        case setNotTime(Bool)
        
        case updateFamilyDataSource([FamilySection.Item])
        case updatePostDataSource([PostSection.Item])
    }
    
    struct State {
        var isNotTime: Bool = false
        var isSelfUploaded: Bool = true
        var isAllFamilyMembersUploaded: Bool = false
        
        @Pulse var familySection: FamilySection.Model = FamilySection.Model(model: 0, items: [])
        @Pulse var postSection: PostSection.Model = PostSection.Model(model: 0, items: [])
        
        var isShowingNoPostTodayView: Bool = false
        var isShowingInviteFamilyView: Bool = false
    }
    
    let initialState: State = State()
    private let provider: GlobalStateProviderProtocol
    private let familyUseCase: SearchFamilyMemberUseCaseProtocol
    private let postUseCase: PostListUseCaseProtocol
    private let inviteFamilyUseCase: FamilyViewUseCaseProtocol
    
    init(provider: GlobalStateProviderProtocol, familyUseCase: SearchFamilyMemberUseCaseProtocol, postUseCase: PostListUseCaseProtocol, inviteFamilyUseCase: FamilyViewUseCaseProtocol) {
        self.provider = provider
        self.familyUseCase = familyUseCase
        self.postUseCase = postUseCase
        self.inviteFamilyUseCase = inviteFamilyUseCase
    }
}

extension HomeViewReactor {
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        return provider.timerGlobalState.event
            .take(1)
            .flatMap { event in
                switch event {
                case .notTime:
                    return Observable.merge([
                        mutation,
                        Observable<Mutation>.just(Mutation.setNotTime(true))
                        ])
                default:
                    return Observable.merge([mutation])
                }
            }
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return self.viewWillAppear()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .updateFamilyDataSource(let familySectionItem):
            newState.familySection.items = familySectionItem
        case .updatePostDataSource(let postSectionItem):
            newState.postSection.items = postSectionItem
        case .setSelfUploaded(let isSelfUploaded):
            newState.isSelfUploaded = isSelfUploaded
        case .setAllFamilyUploaded(let isAllUploaded):
            newState.isAllFamilyMembersUploaded = isAllUploaded
        case .setInviteFamilyView(let isShow):
            newState.isShowingInviteFamilyView = isShow
        case .setNoPostTodayView(let isShow):
            newState.isShowingNoPostTodayView = isShow
        case .setNotTime(let isNotTime):
            if isNotTime {
                newState.isSelfUploaded = isNotTime
                newState.isShowingNoPostTodayView = isNotTime
            }
            newState.isNotTime = isNotTime
        }
        
        return newState
    }
}

extension HomeViewReactor {
    private func viewWillAppear() -> Observable<Mutation> {
        let familyListObservable = getFamilyList()

        if currentState.isNotTime {
            return handleFamilyListWhenNotTime(familyListObservable)
        } else {
            let postListObservable = getPostList()
            return handleFamilyAndPostList(familyListObservable, postListObservable)
        }
    }

    private func handleFamilyListWhenNotTime(_ familyListObservable: Observable<SearchFamilyPage?>) -> Observable<Mutation> {
        return familyListObservable
            .flatMap { familyList -> Observable<Mutation> in
                guard let familyList = familyList, familyList.members.count >= 2 else {
                    return Observable.just(Mutation.setInviteFamilyView(true))
                }

                let familySectionItem = familyList.members.map(FamilySection.Item.main)
                return Observable.from([
                    Mutation.setInviteFamilyView(false),
                    Mutation.updateFamilyDataSource(familySectionItem)
                ])
            }
    }

    private func handleFamilyAndPostList(_ familyListObservable: Observable<SearchFamilyPage?>, _ postListObservable: Observable<PostListPage?>) -> Observable<Mutation> {
        return Observable.zip(postListObservable, familyListObservable)
            .flatMap { (postList, familyList) -> Observable<Mutation> in
                guard let familyList = familyList, familyList.members.count >= 1 else {
                    return Observable.empty()
                }

                var mutations: [Mutation] = [
                    Mutation.setInviteFamilyView(familyList.members.count <= 1)
                ]

                if let postList = postList, !postList.postLists.isEmpty {
                    let sortedFamilyMembers = self.sortFamilyMembersByPostRank(familyList.members, with: postList.postLists)
                    let familySectionItem = sortedFamilyMembers.map(FamilySection.Item.main)
                    mutations.append(Mutation.updateFamilyDataSource(familySectionItem))

                    let postSectionItem = postList.postLists.map(PostSection.Item.main)
                    mutations.append(contentsOf: [
                        Mutation.updatePostDataSource(postSectionItem),
                        Mutation.setSelfUploaded(postList.selfUploaded),
                        Mutation.setAllFamilyUploaded(postList.allFamilyMembersUploaded)
                    ])
                } else {
                    let familySectionItem = familyList.members.map(FamilySection.Item.main)
                    mutations.append(contentsOf: [
                        Mutation.updateFamilyDataSource(familySectionItem),
                        Mutation.setSelfUploaded(false),
                        Mutation.setNoPostTodayView(true)
                    ])
                }

                return Observable.from(mutations)
            }
    }

    private func sortFamilyMembersByPostRank(_ familyMembers: [ProfileData], with postLists: [PostListData]) -> [ProfileData] {
        let authorIdsInOrder = postLists.compactMap { $0.author?.memberId }

        var sortedFamilyMembers = familyMembers.sorted { (familyMember1, familyMember2) -> Bool in
               guard
                   familyMember1.memberId != familyMembers.first?.memberId,
                   familyMember2.memberId != familyMembers.first?.memberId,
                   let index1 = authorIdsInOrder.firstIndex(of: familyMember1.memberId),
                   let index2 = authorIdsInOrder.firstIndex(of: familyMember2.memberId) else {
                   return false
               }
               return index1 > index2
        }
        
        sortedFamilyMembers = sortedFamilyMembers.enumerated().map { (index, element) -> ProfileData in
            var mutableFamilyMember = element
            mutableFamilyMember.postRank = index + 1
            return mutableFamilyMember
        }
        
        let myMemberId = App.Repository.member.memberID.value
        if let index = familyMembers.firstIndex(where: { $0.memberId == myMemberId }) {
            let element = sortedFamilyMembers.remove(at: index)
            sortedFamilyMembers.insert(element, at: 0)
        }
        
        return sortedFamilyMembers
    }

    private func getPostList() -> Observable<PostListPage?> {
        guard !currentState.isNotTime else {
            return Observable.empty()
        }
        let query = PostListQuery(page: 1, size: 50, date: Date().toFormatString(with: "YYYY-MM-DD"), sort: .desc)
        return postUseCase.excute(query: query).asObservable()
    }
    
    private func getFamilyList() -> Observable<SearchFamilyPage?> {
        let query = SearchFamilyQuery(page: 1, size: 50)
        return familyUseCase.excute(query: query).asObservable()
    }
    
}
