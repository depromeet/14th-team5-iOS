//
//  HomeViewReactor.swift
//  App
//
//  Created by 마경미 on 05.12.23.
//

import UIKit

import Core
import Domain
import DesignSystem

import ReactorKit
import RxDataSources
import Kingfisher

final class MainViewReactor: Reactor {
    enum Action {
        case calculateTime
        case setTimer(Bool, Int)
        case fetchMainUseCase
        case fetchMainNightUseCase
        
        case didTapSegmentControl(PostType)
        case pickConfirmButtonTapped(String, String)
    }
    
    enum Mutation {
        case updateMainData(MainData)
        case updateMainNight(MainNightData)
        
        case setInTime(Bool)
        case setPageIndex(Int)
        case setCamerEnabled
        case setBalloonText
        case setDescriptionText
        
        case setPickSuccessToastMessage(String)
        case setCopySuccessToastMessage
        case setFailureToastMessage
        
        case setPickAlertView(String, String)
    }
    
    struct State {
        var isInTime: Bool = true
        var pageIndex: Int = 0
        var leftCount: Int = 0
        
        var missionText: String = ""
        var balloonText: BalloonText = .survivalStandard
        var description: Description = .survivalNone
        
        var isFamilySurvivalUploadedToday: Bool = false
        var isFamilyMissionUploadedToday: Bool = false
        var isMeSurvivalUploadedToday: Bool = false
        var isMeMissionUploadedToday: Bool = false
        var isMissionUnlocked: Bool = false
        
        @Pulse var cameraEnabled: Bool = false
        
        @Pulse var pickers: [Picker] = []
        @Pulse var contributor: FamilyRankData = FamilyRankData.empty
        @Pulse var familySection: [FamilySection.Item] = []
        
        @Pulse var shouldPresentPickAlert: (String, String)?
        @Pulse var shouldPresentPickSuccessToastMessage: String?
        @Pulse var shouldPresentCopySuccessToastMessage: Bool = false
        @Pulse var shouldPresentFailureToastMessage: Bool = false
    }
    
    let initialState: State = State()
    private let fetchMainUseCase: FetchMainUseCaseProtocol
    private let fetchMainNightUseCase: FetchMainNightUseCaseProtocol
    private let pickUseCase: PickUseCaseProtocol
    private let provider: GlobalStateProviderProtocol
    
    init(
        fetchMainUseCase: FetchMainUseCaseProtocol,
        fetchMainNightUseCase: FetchMainNightUseCaseProtocol,
        pickUseCase: PickUseCaseProtocol,
        provider: GlobalStateProviderProtocol) {
            self.fetchMainUseCase = fetchMainUseCase
            self.fetchMainNightUseCase = fetchMainNightUseCase
            self.pickUseCase = pickUseCase
            self.provider = provider
        }
}

extension MainViewReactor {
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let homeMutation = provider.mainService.event
            .flatMap { event in
                switch event {
                case let .presentPickAlert(name, id):
                    return Observable<Mutation>.just(.setPickAlertView(name, id))
                case .refreshMain:
                    return self.mutate(action: .calculateTime)
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
                .asObservable()
                .flatMap { result -> Observable<MainViewReactor.Mutation> in
                    guard let data = result else {
                        return Observable.empty()
                    }
                    return Observable.concat(
                        Observable.just(.updateMainData(data)),
                        Observable.just(.setBalloonText),
                        Observable.just(.setCamerEnabled)
                    )
                }
        case .fetchMainNightUseCase:
            return fetchMainNightUseCase.execute()
                .asObservable()
                .flatMap { result -> Observable<MainViewReactor.Mutation> in
                    guard let data = result else {
                        return Observable.empty()
                    }
                    return Observable.just(.updateMainNight(data))
                }
        case .setTimer(let isInTime, let time):
            if isInTime {
                return Observable<Int>
                    .timer(.seconds(time), scheduler: MainScheduler.instance)
                    .flatMap {_ in
                        return Observable.concat([
                            Observable.just(Mutation.setInTime(false)),
                            self.mutate(action: .fetchMainNightUseCase)
                        ])
                    }
            } else {
                return Observable<Int>
                    .timer(.seconds(time), scheduler: MainScheduler.instance)
                    .flatMap {_ in
                        return Observable.concat([
                            Observable.just(Mutation.setInTime(true)),
                            self.mutate(action: .fetchMainUseCase)
                        ])
                    }
            }
        case .calculateTime:
            let (isInTime, time) = MainViewReactor.calculateRemainingTime()
            
            if isInTime {
                return Observable.concat([
                    Observable.just(Mutation.setInTime(true)),
                    self.mutate(action: .fetchMainUseCase),
                    self.mutate(action: .setTimer(isInTime, time))
                ])
            } else {
                return Observable.concat([
                    Observable.just(Mutation.setInTime(false)),
                    self.mutate(action: .fetchMainNightUseCase),
                    self.mutate(action: .setTimer(isInTime, time))
                ])
                
            }
        case .didTapSegmentControl(let type):
            return Observable.concat(
                Observable.just(.setPageIndex(type.getIndex())),
                Observable.just(.setBalloonText),
                Observable.just(.setDescriptionText),
                Observable.just(.setCamerEnabled)
            )
            
        case let .pickConfirmButtonTapped(name, id):
            return pickUseCase.executePickMember(memberId: id)
                .flatMap { response in
                    guard let response = response,
                          response.success else {
                        return Observable<Mutation>.just(.setFailureToastMessage)
                    }
                    self.provider.mainService.showPickButton(false, memberId: id)
                    return Observable.concat(
                        Observable<Mutation>.just(.setPickSuccessToastMessage(name)),
                        self.mutate(action: .calculateTime)
                    )
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setInTime(let isInTime):
            newState.isInTime = isInTime
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
            newState.isMeMissionUploadedToday = data.isMeMissionUploadedToday
            newState.isFamilyMissionUploadedToday = data.isFamilyMissionUploadedToday
            newState.isFamilySurvivalUploadedToday = data.isFamilySurvivalUploadedToday
            newState.leftCount = data.leftUploadCountUntilMissionUnlock
            newState.missionText = data.dailyMissionContent
            newState.pickers = data.pickers
            newState.familySection = FamilySection.Model(
                model: 0,
                items: data.mainFamilyProfileDatas.map {
                    .main(MainFamilyCellReactor($0, service: provider))
                }
            ).items
        case .updateMainNight(let data):
            newState.familySection = FamilySection.Model(model: 0, items: data.mainFamilyProfileDatas.map {
                .main(MainFamilyCellReactor($0, service: provider))
            }).items
            newState.contributor = data.familyRankData
        case let .setPickAlertView(name, id):
            newState.shouldPresentPickAlert = (name, id)
        case .setCamerEnabled:
            if currentState.pageIndex == 0 {
                newState.cameraEnabled = !currentState.isMeSurvivalUploadedToday
            } else {
                if !currentState.isMeMissionUploadedToday && currentState.isMissionUnlocked {
                    newState.cameraEnabled = true
                } else {
                    newState.cameraEnabled = false
                }
            }
        case .setBalloonText:
            if currentState.pageIndex == 0 {
                if currentState.isMeSurvivalUploadedToday {
                    newState.balloonText = .survivalDone
                } else if !currentState.pickers.isEmpty {
                    if currentState.pickers.count <= 1 {
                        newState.balloonText = .picker(currentState.pickers[0])
                    } else {
                        newState.balloonText = .pickers(currentState.pickers)
                    }
                } else {
                    newState.balloonText = .survivalStandard
                }
            } else {
                if !currentState.isMissionUnlocked {
                    newState.balloonText = .missionLocked
                } else {
                    if !currentState.isMeSurvivalUploadedToday {
                        newState.balloonText = .cantMission
                    } else if currentState.isMeMissionUploadedToday {
                        newState.balloonText = .missionDone
                    } else {
                        newState.balloonText = .canMission
                    }
                }
            }
        case .setDescriptionText:
            if currentState.pageIndex == 0 {
                if currentState.isFamilySurvivalUploadedToday {
                    newState.description = .survivalFull
                } else {
                    newState.description = .survivalNone
                }
            } else {
                if !currentState.isMissionUnlocked {
                    newState.description = .missionNone(currentState.leftCount)
                } else {
                    if currentState.isFamilyMissionUploadedToday {
                        newState.description = .missionFull
                    } else {
                        newState.description = .mission(currentState.missionText)
                    }
                }
            }
        }
        
        return newState
    }
}

extension MainViewReactor {
    private static func calculateRemainingTime() -> (Bool, Int) {
        let calendar = Calendar.current
        let currentTime = Date()
        
        let currentHour = calendar.component(.hour, from: currentTime)
        
        if currentHour >= 10 {
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
