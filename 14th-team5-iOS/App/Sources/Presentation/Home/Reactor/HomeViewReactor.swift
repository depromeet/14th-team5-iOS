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
        case viewDidLoad
        case viewWillAppear
        case refresh
        case tapInviteFamily
    }
    
    enum Mutation {
        case setSelfUploaded(Bool)
        case setAllFamilyUploaded(Bool)
        case setInviteFamilyView(Bool)
        case setNoPostTodayView(Bool)
        case setInTime(Bool)
        
        case updateFamilyDataSource([FamilySection.Item])
        case updatePostDataSource([PostSection.Item])
        
        case showShareAcitivityView(URL?)
        case setCopySuccessToastMessageView
        case setFetchFailureToastMessageView
        case setSharePanel(String)
    }
    
    struct State {
        var isInTime: Bool = false
        @Pulse var isSelfUploaded: Bool = true
        @Pulse var isRefreshEnd: Bool = true
        var isAllFamilyMembersUploaded: Bool = false
        
        @Pulse var familySection: FamilySection.Model = FamilySection.Model(model: 0, items: [])
        @Pulse var postSection: PostSection.Model = PostSection.Model(model: 0, items: [])
        
        @Pulse var familyInvitationLink: URL?
        @Pulse var shouldPresentCopySuccessToastMessageView: Bool = false
        @Pulse var shouldPresentFetchFailureToastMessageView: Bool = false
        
        var isShowingNoPostTodayView: Bool = false
        var isShowingInviteFamilyView: Bool = false
    }
    
    let initialState: State = State()
    let provider: GlobalStateProviderProtocol
    private let familyUseCase: FamilyUseCaseProtocol
    private let postUseCase: PostListUseCaseProtocol
    
    init(provider: GlobalStateProviderProtocol, familyUseCase: FamilyUseCaseProtocol, postUseCase: PostListUseCaseProtocol) {
        self.provider = provider
        self.familyUseCase = familyUseCase
        self.postUseCase = postUseCase
    }
}

extension HomeViewReactor {
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
            return self.viewWillAppear()
        case .viewDidLoad:
            let (isInTime, time) = self.calculateRemainingTime()
            return Observable.just(Mutation.setInTime(isInTime))
            
            if isInTime {
                return Observable<Int>
                    .timer(.seconds(time), scheduler: MainScheduler.instance)
                    .flatMap {_ in
                        return Observable.concat([Observable.just(Mutation.setInTime(false)),
                                                  Observable.just(Mutation.setSelfUploaded(true))])
                    }
            } else {
                return Observable<Int>
                    .timer(.seconds(time), scheduler: MainScheduler.instance)
                    .flatMap {_ in
                        return Observable.concat([Observable.just(Mutation.setInTime(true)),
                                                  Observable.just(Mutation.setSelfUploaded(false))])
                    }
                                        
            }
        case .refresh:
            return self.mutate(action: .viewWillAppear)
        case .tapInviteFamily:
                   MPEvent.Home.shareLink.track(with: nil)
                   return familyUseCase.executeFetchInvitationUrl()
                       .map {
                           guard let invitationLink = $0?.url else {
                               return .setFetchFailureToastMessageView
                           }
                           return .setSharePanel(invitationLink)
                       }
        }
        
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .updateFamilyDataSource(let familySectionItem):
            newState.isRefreshEnd = true
            newState.familySection.items = familySectionItem
        case .updatePostDataSource(let postSectionItem):
            newState.postSection.items = postSectionItem
            App.Repository.member.postId.accept(UserDefaults.standard.postId)
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
        case let .showShareAcitivityView(url):
            newState.familyInvitationLink = url
        case .setCopySuccessToastMessageView:
              newState.shouldPresentCopySuccessToastMessageView = true
          case .setFetchFailureToastMessageView:
              newState.shouldPresentFetchFailureToastMessageView = true
          case let .setSharePanel(urlString):
              newState.familyInvitationLink = URL(string: urlString)
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

    private func handleFamilyListWhenNotTime(_ familyListObservable: Observable<PaginationResponseFamilyMemberProfile?>) -> Observable<Mutation> {
        return familyListObservable
            .flatMap { familyList -> Observable<Mutation> in
                guard let familyList = familyList, familyList.results.count >= 2 else {
                    return Observable.just(Mutation.setInviteFamilyView(true))
                }

                let familySectionItem = familyList.results.map(FamilySection.Item.main)
                return Observable.from([
                    Mutation.setNoPostTodayView(true),
                    Mutation.setInviteFamilyView(false),
                    Mutation.setSelfUploaded(true),
                    Mutation.updateFamilyDataSource(familySectionItem),
                    Mutation.updatePostDataSource([])
                ])
            }
    }

    private func handleFamilyAndPostList(_ familyListObservable: Observable<PaginationResponseFamilyMemberProfile?>, _ postListObservable: Observable<PostListPage?>) -> Observable<Mutation> {
        return Observable.combineLatest(postListObservable, familyListObservable)
            .flatMap { (postList, familyList) -> Observable<Mutation> in
                guard let familyList = familyList, familyList.results.count >= 1 else {
                    return Observable.empty()
                }

                var mutations: [Mutation] = [
                    Mutation.setInviteFamilyView(familyList.results.count <= 1)
                ]

                if let postList = postList, !postList.postLists.isEmpty {
                    let sortedFamilyMembers = self.sortFamilyMembersByPostRank(familyList.results, with: postList.postLists)
                    let familySectionItem = sortedFamilyMembers.map(FamilySection.Item.main)
                    mutations.append(Mutation.updateFamilyDataSource(familySectionItem))

                    let postSectionItem = postList.postLists.map(PostSection.Item.main)
                    mutations.append(contentsOf: [
                        Mutation.updatePostDataSource(postSectionItem),
                        Mutation.setSelfUploaded(postList.selfUploaded),
                        Mutation.setNoPostTodayView(false),
                        Mutation.setAllFamilyUploaded(postList.allFamilyMembersUploaded)
                    ])
                } else {
                    let familySectionItem = familyList.results.map(FamilySection.Item.main)
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

        let query = PostListQuery(page: 1, size: 50, date: DateFormatter.dashYyyyMMdd.string(from: Date()), sort: .desc)
        return postUseCase.excute(query: query).asObservable()
    }
    
    private func getFamilyList() -> Observable<PaginationResponseFamilyMemberProfile?> {
        let query = FamilyPaginationQuery()
        return familyUseCase.executeFetchPaginationFamilyMembers(query: query)
    }
    
    private func calculateRemainingTime() -> (Bool, Int) {
        let calendar = Calendar.current
        let currentTime = Date()
        
        // Get components of the current time
        let currentHour = calendar.component(.hour, from: currentTime)

        if currentHour >= 12 {
            if let nextMidnight = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: currentTime.addingTimeInterval(24 * 60 * 60)) {
                let timeDifference = calendar.dateComponents([.second], from: currentTime, to: nextMidnight)
                return (true, max(0, timeDifference.second ?? 0))
            }
        } else {
            if let nextMidnight = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: currentTime) {
                let timeDifference = calendar.dateComponents([.second], from: currentTime, to: nextMidnight)
                return (false, max(0, timeDifference.second ?? 0))
            }
        }

        return (false, 0)
    }

}
