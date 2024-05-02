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

final class MainViewReactor: Reactor {
    enum Action {
        case viewDidLoad
        case fetchMainUseCase
        
        case didTapSegmentControl(PostType)
        
        case pushWidgetPostDeepLink(WidgetDeepLink)
        case pushNotificationPostDeepLink(NotificationDeepLink)
        case pushNotificationCommentDeepLink(NotificationDeepLink)
    }
    
    enum Mutation {
        case updateMainData(MainData)
        
        case setInTime(Bool)
        
        case setPageIndex(Int)
        case setCopySuccessToastMessageView
        
        case setWidgetPostDeepLink(WidgetDeepLink)
        case setNotificationPostDeepLink(NotificationDeepLink)
        case setNotificationCommentDeepLink(NotificationDeepLink)
    }
    
    struct State {
        var isInTime: Bool
        var pageIndex: Int = 0
        
        @Pulse var isMeSurvivalUploadedToday: Bool = false
        @Pulse var isMissionUnlocked: Bool = false
        @Pulse var familySection: [FamilySection.Item] = []
        
        @Pulse var widgetPostDeepLink: WidgetDeepLink?
        @Pulse var notificationPostDeepLink: NotificationDeepLink?
        @Pulse var notificationCommentDeepLink: NotificationDeepLink?
        
        @Pulse var shouldPresentCopySuccessToastMessageView: Bool = false
    }
    
    let initialState: State
    let fetchMainUseCase: FetchMainUseCaseProtocol
    let provider: GlobalStateProviderProtocol
    
    init(initialState: State, fetchMainUseCase: FetchMainUseCaseProtocol, provider: GlobalStateProviderProtocol) {
        self.initialState = initialState
        self.fetchMainUseCase = fetchMainUseCase
        self.provider = provider
    }
}

extension MainViewReactor {
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
        case .fetchMainUseCase:
            return fetchMainUseCase.execute()
                .flatMap { result -> Observable<MainViewReactor.Mutation> in
                    guard let data = result else {
                        return Observable.empty()
                    }
                    return Observable.just(.updateMainData(data))
                }
        case .viewDidLoad:
            let (_, time) = MainViewReactor.calculateRemainingTime()
            
            if self.currentState.isInTime {
                return Observable<Int>
                    .timer(.seconds(time), scheduler: MainScheduler.instance)
                    .flatMap {_ in
                        return Observable.concat([Observable.just(Mutation.setInTime(false))])
                    }
            } else {
                return Observable<Int>
                    .timer(.seconds(time), scheduler: MainScheduler.instance)
                    .flatMap {_ in
                        return Observable.concat([Observable.just(Mutation.setInTime(true))])
                    }
                                        
            }
        case let .pushWidgetPostDeepLink(deepLink):
            return Observable.concat(
                Observable<Mutation>.just(.setWidgetPostDeepLink(deepLink)) // 다음 화면으로 이동하기
            )
            
        case let .pushNotificationPostDeepLink(deepLink):
            return Observable.concat(
                Observable<Mutation>.just(.setNotificationPostDeepLink(deepLink)) // 다음 화면으로 이동하기
            )
            
        case let .pushNotificationCommentDeepLink(deepLink):
            return Observable.concat(
                Observable<Mutation>.just(.setNotificationCommentDeepLink(deepLink)) // 다음 화면으로 이동하기
            )
        case .didTapSegmentControl(let type):
            return Observable.just(.setPageIndex(type.getIndex()))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setInTime(let isInTime):
            newState.isInTime = isInTime
        case let.setWidgetPostDeepLink(deepLink):
            newState.widgetPostDeepLink = deepLink
        case let .setNotificationPostDeepLink(deepLink):
            newState.notificationPostDeepLink = deepLink
        case let .setNotificationCommentDeepLink(deepLink):
            newState.notificationCommentDeepLink = deepLink
        case .setCopySuccessToastMessageView:
            newState.shouldPresentCopySuccessToastMessageView = true
        case .setPageIndex(let index):
            newState.pageIndex = index
        case .updateMainData(let data):
            newState.isMissionUnlocked = data.isMissionUnlocked
            newState.isMeSurvivalUploadedToday = data.isMeSurvivalUploadedToday
            newState.familySection = data.mainFamilyProfileDatas
        }
        
        return newState
    }
}

extension MainViewReactor {
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
