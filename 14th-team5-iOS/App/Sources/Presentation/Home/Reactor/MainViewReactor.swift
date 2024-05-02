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
        case pickConfirmButtonTapped(String, String)
        
        case pushWidgetPostDeepLink(WidgetDeepLink)
        case pushNotificationPostDeepLink(NotificationDeepLink)
        case pushNotificationCommentDeepLink(NotificationDeepLink)
    }
    
    enum Mutation {
        case updateMainData(MainData)
        
        case setInTime(Bool)
        
        case setPageIndex(Int)
        
        case setPickSuccessToastMessage(String)
        case setCopySuccessToastMessage
        case setFailureToastMessage
        
        case setPickAlertView(String, String)
        
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
    
        @Pulse var shouldPresentPickAlert: (String, String)?
        @Pulse var shouldPresentPickSuccessToastMessage: String?
        @Pulse var shouldPresentCopySuccessToastMessage: Bool = false
        @Pulse var shouldPresentFailureToastMessage: Bool = false
    }
    
    let initialState: State
    let fetchMainUseCase: FetchMainUseCaseProtocol
    let pickUseCase: PickUseCaseProtocol
    let provider: GlobalStateProviderProtocol
    
    init(
        initialState: State,
        fetchMainUseCase: FetchMainUseCaseProtocol,
        pickUseCase: PickUseCaseProtocol,
        provider: GlobalStateProviderProtocol
    ) {
        self.initialState = initialState
        self.fetchMainUseCase = fetchMainUseCase
        self.pickUseCase = pickUseCase
        self.provider = provider
    }
}

extension MainViewReactor {
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let homeMutation = provider.homeService.event
            .flatMap { event in
                switch event {
                case let .presentPickAlert(name, id):
                    return Observable<Mutation>.just(.setPickAlertView(name, id))
                default:
                    return Observable<Mutation>.empty()
                }
            }
        
        let eventMutation = provider.activityGlobalState.event
            .flatMap { event -> Observable<Mutation> in
                switch event {
                case .didTapCopyInvitationUrlAction:
                    return Observable<Mutation>.just(.setCopySuccessToastMessage)
                default:
                    return Observable<Mutation>.empty()
                }
            }
        
        return Observable<Mutation>.merge(mutation, eventMutation, homeMutation)
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
            
        case let .pickConfirmButtonTapped(name, id):
            return pickUseCase.executePickMember(memberId: id)
                .flatMap { response in
                    guard let response = response,
                          response.success else {
                        return Observable<Mutation>.just(.setFailureToastMessage)
                    }
                    self.provider.homeService.showPickButton(false, memberId: id)
                    return Observable<Mutation>.just(.setPickSuccessToastMessage(name))
                }
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
        case .setCopySuccessToastMessage:
            newState.shouldPresentCopySuccessToastMessage = true
        case let .setPickSuccessToastMessage(name):
            newState.shouldPresentPickSuccessToastMessage = name
        case .setFailureToastMessage:
            newState.shouldPresentFailureToastMessage = true
        case .setPageIndex(let index):
            newState.pageIndex = index
        case .updateMainData(let data):
            newState.isMissionUnlocked = data.isMissionUnlocked
            newState.isMeSurvivalUploadedToday = data.isMeSurvivalUploadedToday
            newState.familySection = FamilySection.Model(
                model: 0,
                items: data.mainFamilyProfileDatas.map {
                    .main(MainFamilyCellReactor($0, service: provider))
                }
            ).items
        case let .setPickAlertView(name, id):
            newState.shouldPresentPickAlert = (name, id)
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
