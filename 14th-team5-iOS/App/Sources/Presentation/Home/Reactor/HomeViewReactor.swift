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
        case checkInTime
        case viewWillAppear
    }
    
    enum Mutation {
        case setSelfUploaded(Bool)
        case setAllFamilyUploaded(Bool)
        case setInviteFamilyView(Bool)
        case setNoPostTodayView(Bool)
        case setInTime(Bool)
        
        case updateFamilyDataSource([FamilySection.Item])
        case updatePostDataSource([PostSection.Item])
    }
    
    struct State {
        var isInTime: Bool = true
        var isSelfUploaded: Bool = false
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
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return self.viewWillAppear()
        case .checkInTime:
            return Observable<Int>
                .timer(.seconds(self.calculateRemainingTime()), scheduler: MainScheduler.instance)
                .filter { $0 <= 0 }
                .flatMap {_ in
                    return Observable.concat([Observable.just(Mutation.setInTime(false)),
                                              self.mutate(action: .viewWillAppear)])
                }
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
        case .setInTime(let isInTime):
            newState.isInTime = isInTime
        }
        
        return newState
    }
}

extension HomeViewReactor {
    private func viewWillAppear() -> Observable<Mutation> {
        let familyListObservable = getFamilyList()

        if currentState.isInTime {
            let postListObservable = getPostList()
            return handleFamilyAndPostList(familyListObservable, postListObservable)
        } else {
            return handleFamilyListWhenNotTime(familyListObservable)
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
                    Mutation.setSelfUploaded(true),
                    Mutation.updateFamilyDataSource(familySectionItem)
                ])
            }
    }

    private func handleFamilyAndPostList(_ familyListObservable: Observable<SearchFamilyPage?>, _ postListObservable: Observable<PostListPage?>) -> Observable<Mutation> {
        return Observable.combineLatest(postListObservable, familyListObservable)
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
        let authorProfileDatas = postLists.compactMap { $0.author }.reversed()
        let subtractMembers = Array(Set(familyMembers).subtracting(Set(authorProfileDatas)))
        
        var sortedMembers = authorProfileDatas + subtractMembers
        for index in 0..<authorProfileDatas.count {
            sortedMembers[index].postRank = index + 1
        }
        
        let myMemberId = App.Repository.member.memberID.value
        if let index = sortedMembers.firstIndex(where: { $0.memberId == myMemberId }) {
            let element = sortedMembers.remove(at: index)
            sortedMembers.insert(element, at: 0)
        }
        
        return sortedMembers
    }

    private func getPostList() -> Observable<PostListPage?> {
        guard currentState.isInTime else {
            return Observable.empty()
        }
        let query = PostListQuery(page: 1, size: 50, date: Date().toFormatString(with: "YYYY-MM-DD"), sort: .desc)
        return postUseCase.excute(query: query).asObservable()
    }
    
    private func getFamilyList() -> Observable<SearchFamilyPage?> {
        let query = SearchFamilyQuery(page: 1, size: 50)
        return familyUseCase.excute(query: query).asObservable()
    }
    
    private func calculateRemainingTime() -> Int {
        let calendar = Calendar.current
        let currentTime = Date()
        
        let isAfterNoon = calendar.component(.hour, from: currentTime) >= 12
        
        if isAfterNoon {
            if let nextMidnight = calendar.date(bySettingHour: 18, minute: 10, second: 0, of: /*currentTime.addingTimeInterval(24 * 60 * 60)*/ currentTime) {
                let timeDifference = calendar.dateComponents([.second], from: currentTime, to: nextMidnight)
                return max(0, timeDifference.second ?? 0)
            }
        }
        
        return 0
    }
}
