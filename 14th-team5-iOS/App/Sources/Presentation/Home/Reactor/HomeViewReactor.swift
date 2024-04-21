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
        case tapCameraButton
        
        case pushWidgetPostDeepLink(WidgetDeepLink)
        case pushNotificationPostDeepLink(NotificationDeepLink)
        case pushNotificationCommentDeepLink(NotificationDeepLink)
    }
    
    enum Mutation {
        case setSelfUploaded(Bool)
        case setAllFamilyUploaded(Bool)
        case setNoPostTodayView(Bool)
        case setInTime(Bool)
        case showCameraView(Bool)
        
        case updatePostDataSource([PostSection.Item])
        
//        case showShareAcitivityView(URL?)
        case setCopySuccessToastMessageView
        
        case setWidgetPostDeepLink(WidgetDeepLink)
        case setNotificationPostDeepLink(NotificationDeepLink)
        case setNotificationCommentDeepLink(NotificationDeepLink)
    }
    
    struct State {
        var isInTime: Bool
        @Pulse var isSelfUploaded: Bool = true
        @Pulse var isRefreshEnd: Bool = true
        var isAllFamilyMembersUploaded: Bool = false
        
        @Pulse var postSection: PostSection.Model = PostSection.Model(model: 0, items: [])
        
        var isShowingNoPostTodayView: Bool = false
        @Pulse var isShowingCameraView: Bool = false
        
        @Pulse var widgetPostDeepLink: WidgetDeepLink?
        @Pulse var notificationPostDeepLink: NotificationDeepLink?
        @Pulse var notificationCommentDeepLink: NotificationDeepLink?
        
        @Pulse var shouldPresentCopySuccessToastMessageView: Bool = false
    }
    
    let initialState: State
    let provider: GlobalStateProviderProtocol
    private let postUseCase: PostListUseCaseProtocol
    
    init(provider: GlobalStateProviderProtocol, familyUseCase: FamilyUseCaseProtocol, postUseCase: PostListUseCaseProtocol) {
        self.initialState = State(isInTime: HomeViewReactor.calculateRemainingTime().0)
        self.provider = provider
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
            let (_, time) = HomeViewReactor.calculateRemainingTime()
            
            if self.currentState.isInTime {
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
        case .tapCameraButton:
            return Observable.just(.showCameraView(self.currentState.isInTime))
            
        case let .pushWidgetPostDeepLink(deepLink):
            return Observable.concat(
                self.viewWillAppear(), // 포스트 네트워크 통신을 완료 한 후,
                Observable<Mutation>.just(.setWidgetPostDeepLink(deepLink)) // 다음 화면으로 이동하기
            )
            
        case let .pushNotificationPostDeepLink(deepLink):
            return Observable.concat(
                self.viewWillAppear(), // 포스트 네트워크 통신을 완료 한 후,
                Observable<Mutation>.just(.setNotificationPostDeepLink(deepLink)) // 다음 화면으로 이동하기
            )
            
        case let .pushNotificationCommentDeepLink(deepLink):
            return Observable.concat(
                self.viewWillAppear(), // 포스트 네트워크 통신을 완료 한 후,
                Observable<Mutation>.just(.setNotificationCommentDeepLink(deepLink)) // 다음 화면으로 이동하기
            )
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .updatePostDataSource(let postSectionItem):
            newState.postSection.items = postSectionItem
            App.Repository.member.postId.accept(UserDefaults.standard.postId)
        case .setSelfUploaded(let isSelfUploaded):
            newState.isSelfUploaded = isSelfUploaded
        case .setAllFamilyUploaded(let isAllUploaded):
            newState.isAllFamilyMembersUploaded = isAllUploaded
        case .setNoPostTodayView(let isShow):
            newState.isShowingNoPostTodayView = isShow
        case .setInTime(let isInTime):
            newState.isInTime = isInTime
        case let .showCameraView(isShow):
            newState.isShowingCameraView = isShow
        case let.setWidgetPostDeepLink(deepLink):
            newState.widgetPostDeepLink = deepLink
        case let .setNotificationPostDeepLink(deepLink):
            newState.notificationPostDeepLink = deepLink
        case let .setNotificationCommentDeepLink(deepLink):
            newState.notificationCommentDeepLink = deepLink
        case .setCopySuccessToastMessageView:
            newState.shouldPresentCopySuccessToastMessageView = true
        }
        
        return newState
    }
}

extension HomeViewReactor {
    private func viewWillAppear() -> Observable<Mutation> {
        let postListObservable = getPostList()
        return handleFamilyAndPostList(postListObservable)
    }

    private func handleFamilyAndPostList(_ postListObservable: Observable<PostListPage?>) -> Observable<Mutation> {
        return postListObservable
            .flatMap { (postList) -> Observable<Mutation> in
                var mutations: [Mutation] = []
                if let postList = postList, !postList.postLists.isEmpty {
                    let postSectionItem = postList.postLists.map(PostSection.Item.main)
                    mutations.append(contentsOf: [
                        Mutation.updatePostDataSource(postSectionItem),
                        Mutation.setNoPostTodayView(false),
                        Mutation.setAllFamilyUploaded(postList.allFamilyMembersUploaded)
                    ])
                }
                
                return Observable.concat(Observable.from(mutations), self.postUseCase.excute().asObservable().take(1).map { Mutation.setSelfUploaded($0) })
            }
    }

    private func getPostList() -> Observable<PostListPage?> {
        guard currentState.isInTime else {
            return Observable.empty()
        }

        let query = PostListQuery(page: 1, size: 50, date: DateFormatter.dashYyyyMMdd.string(from: Date()), sort: .desc)
        return postUseCase.excute(query: query).asObservable()
    }
    
    private static func calculateRemainingTime() -> (Bool, Int) {
        let calendar = Calendar.current
        let currentTime = Date()
        
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
