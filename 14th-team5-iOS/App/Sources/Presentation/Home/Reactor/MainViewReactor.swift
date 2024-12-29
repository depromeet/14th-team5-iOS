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
import Util

import ReactorKit
import RxDataSources
import Kingfisher

final class MainViewReactor: Reactor {
    enum TapAction {
        case cameraButtonTap
        case navigationRightButtonTap
        case navigationLeftButtonTap
        case contributorNextButtonTap
    }
    
    enum OpenType {
        case cameraViewController(UploadLocation)
        case survivalAlert
        case pickAlert(String, String)
        case widgetAlert
        case missionUnlockedAlert
        case weeklycalendarViewController(String)
        case familyManagementViewController
        case monthlyCalendarViewController
        case showToastMessage(UIImage?, String)
        case showErrorToast
    }
    
    enum Action {
        case calculateTime
        case setTimer(Bool, Int)
        
        case fetchMainUseCase
        case fetchMainNightUseCase
        
        case checkIsFirstWidgetAlert
        case checkIsFirstFamilyManagement
        case checkMissionAlert(Bool, Bool)
        
        case openNextViewController(TapAction)
        case didTapSegmentControl(PostType)
        case pickConfirmButtonTapped
    }
    
    enum Mutation {
        case updateMainData(MainViewEntity)
        case updateMainNight(NightMainViewEntity)
        
        case setInTime(Bool)
        case setPageIndex(Int)
        case setCamerEnabled
        case setBalloonText
        case setDescriptionText
        
        case setFamilyManagement(Bool)
        
        case setPickMember(String, String)
    }
    
    struct State {
        var isInTime: Bool?
        var pageIndex: Int = 0
        var leftCount: Int = 0
        
        var familyname: String?
        var missionText: String = ""
        var balloonText: BalloonText = .survivalStandard
        var description: Description = .survivalNone
        
        var isFirstFamilyManagement: Bool = false
        var isFamilySurvivalUploadedToday: Bool = false
        var isFamilyMissionUploadedToday: Bool = false
        var isMeSurvivalUploadedToday: Bool = false
        var isMeMissionUploadedToday: Bool = false
        var isMissionUnlocked: Bool = false
        
        @Pulse var pickedMember: (memberId: String, name: String)? = nil
        
        @Pulse var cameraEnabled: Bool = false
        
        @Pulse var pickers: [Picker] = []
        @Pulse var contributor: FamilyRankData = FamilyRankData.empty
        @Pulse var familySection: [FamilySection.Item] = []
    }
    
    let initialState: State = State()
    
    @Navigator var navigator: MainNavigatorProtocol
    
    @Injected var createPickUseCase: CreateMembersPickUseCaseProtocol
    @Injected var provider: ServiceProviderProtocol
    @Injected var fetchMainUseCase: FetchMainUseCaseProtocol
    @Injected var isFirstWidgetAlertUseCase: IsFirstWidgetAlertUseCaseProtocol
    @Injected var fetchMainNightUseCase: FetchNightMainViewUseCaseProtocol
    @Injected var checkMissionAlertShowUseCase: CheckMissionAlertShowUseCaseProtocol
    @Injected var isFirstFamilyManagementUseCase: IsFirstFamilyManagementUseCaseProtocol
    @Injected var saveIsFirstFamilyManagementUseCase: SaveIsFirstFamilyManagementUseCaseProtocol
    @Injected var saveIsFirstWidgetAlertUseCase: SaveIsFirstWidgetAlertUseCaseProtocol
}

extension MainViewReactor {
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let homeMutation = provider.mainService.event
            .flatMap { event -> Observable<Mutation> in
                switch event {
                case let .presentPickAlert(name, id):
                    self.pushViewController(type: .pickAlert(name, id))
                    return .just(.setPickMember(id, name))
                case .refreshMain:
                    return self.mutate(action: .calculateTime)
                default:
                    return .empty()
                }
            }
        
        return Observable<Mutation>.merge(mutation, homeMutation)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchMainUseCase:
            return fetchMainUseCase.execute()
                .asObservable()
                .flatMap { data -> Observable<Mutation> in
                    return Observable.concat(
                        .just(.updateMainData(data)),
                        .just(.setBalloonText),
                        .just(.setCamerEnabled),
                        self.mutate(action: .checkMissionAlert(data.isMissionUnlocked, data.isMeSurvivalUploadedToday))
                    )
                }
        case .fetchMainNightUseCase:
            return fetchMainNightUseCase.execute()
                .asObservable()
                .flatMap { data -> Observable<Mutation> in
                    return .just(.updateMainNight(data))
                }
        case .setTimer(let isInTime, let time):
            if isInTime {
                return Observable<Int>
                    .timer(.seconds(time), scheduler: MainScheduler.instance)
                    .flatMap {_ in
                        return Observable.concat([
                            .just(Mutation.setInTime(false)),
                            self.mutate(action: .fetchMainNightUseCase),
                            .just(Mutation.setDescriptionText)
                        ])
                    }
            } else {
                return Observable<Int>
                    .timer(.seconds(time), scheduler: MainScheduler.instance)
                    .flatMap {_ in
                        return Observable.concat([
                            .just(Mutation.setInTime(true)),
                            self.mutate(action: .fetchMainUseCase)
                        ])
                    }
            }
        case .calculateTime:
            let (isInTime, time) = self.calculateRemainingTime()
            if isInTime {
                return Observable.concat([
                    .just(.setInTime(true)),
                    self.mutate(action: .fetchMainUseCase),
                    self.mutate(action: .setTimer(isInTime, time))
                ])
            } else {
                return Observable.concat([
                    .just(.setInTime(false)),
                    self.mutate(action: .fetchMainNightUseCase),
                    self.mutate(action: .setTimer(isInTime, time))
                ])
                
            }
        case .didTapSegmentControl(let type):
            return Observable.concat(
                .just(.setPageIndex(type.getIndex())),
                .just(.setBalloonText),
                .just(.setDescriptionText),
                .just(.setCamerEnabled)
            )
            
        case let .pickConfirmButtonTapped:
            guard let pickedMember = currentState.pickedMember else {
                return .empty()
            }
            return createPickUseCase.execute(memberId: pickedMember.memberId)
                .compactMap { $0 }
                .flatMap { response -> Observable<Mutation> in
                    if !response.success {
                        self.pushViewController(type: .showErrorToast)
                    } else {
                        self.pushViewController(type:
                                .showToastMessage(DesignSystemAsset.yellowPaperPlane.image,
                                                  "\(pickedMember.name)님에게 생존신고 알림을 보냈어요")
                        )
                    }
                    return .empty()
                }
        case .openNextViewController(let type):
            switch type {
            case .cameraButtonTap:
                if currentState.pageIndex == 0 {
                    self.pushViewController(type: .cameraViewController(.survival))
                } else {
                    if currentState.isMeSurvivalUploadedToday {
                        self.pushViewController(type: .cameraViewController(.mission))
                    } else {
                        self.pushViewController(type: .survivalAlert)
                    }
                }
            case .navigationRightButtonTap:
                self.pushViewController(type: .monthlyCalendarViewController)
            case .navigationLeftButtonTap:
                self.pushViewController(type: .familyManagementViewController)
                
                if currentState.isFirstFamilyManagement {
                    saveIsFirstFamilyManagementUseCase.execute(false)
                    return Observable<Mutation>.just(.setFamilyManagement(false))
                }
            case .contributorNextButtonTap:
                guard let date = currentState.contributor.recentPostDate else {
                    return .empty()
                }
                self.pushViewController(type: .weeklycalendarViewController(date))
            }
            return .empty()
        case .checkMissionAlert(let isUnlocked, let isMeSurvivalUploadedToday):
            if !(isUnlocked && isMeSurvivalUploadedToday) {
                return .empty()
            }
            
            return checkMissionAlertShowUseCase.execute()
                .filter { !$0 }
                .flatMap { isAlreadyShown -> Observable<Mutation> in
                    self.pushViewController(type: .missionUnlockedAlert)
                    return .empty()
                }
        case .checkIsFirstFamilyManagement:
            return isFirstFamilyManagementUseCase.execute()
                .flatMap {
                    return Observable<Mutation>.just(.setFamilyManagement($0))
                }
        case .checkIsFirstWidgetAlert:
            return isFirstWidgetAlertUseCase.execute()
                .filter { $0 }
                .withUnretained(self)
                .flatMap { _ -> Observable<Mutation> in
                    self.pushViewController(type: .widgetAlert)
                    self.saveIsFirstWidgetAlertUseCase.execute(false)
                    return .empty()
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setInTime(let isInTime):
            newState.isInTime = isInTime
        case .setPageIndex(let index):
            newState.pageIndex = index
        case .updateMainData(let data):
            newState = updateMainData(newState, data)
        case .updateMainNight(let data):
            newState.familyname = data.familyName
            newState.familySection = FamilySection.Model(model: 0, items: data.mainFamilyProfileDatas.map {
                .main(MainFamilyCellReactor($0,  service: provider))
            }).items
            newState.contributor = data.familyRankData
        case .setCamerEnabled:
            newState = setCameraEnabled(newState)
        case .setBalloonText:
            newState = setBalloonText(newState)
        case .setDescriptionText:
            newState = setDescriptionText(newState)
        case .setFamilyManagement(let isFirst):
            newState.isFirstFamilyManagement = isFirst
        case .setPickMember(let id, let name):
            newState.pickedMember = (id, name)
        }
        
        return newState
    }
}

extension MainViewReactor {
    private func pushViewController(type: MainViewReactor.OpenType) {
        switch type {
        case .monthlyCalendarViewController:
            navigator.toMonthlyCalendar()
        case .familyManagementViewController:
            navigator.toFamilyManagement()
        case .weeklycalendarViewController(let date):
            navigator.toDailyCalendar(date)
        case .cameraViewController(let type):
            MPEvent.Home.cameraTapped.track(with: nil)
            navigator.toCamera(type)
        case .survivalAlert:
            navigator.showSurvivalAlert()
        case .pickAlert(let name, _):
            navigator.pickAlert(name)
        case .missionUnlockedAlert:
            navigator.missionUnlockedAlert()
        case .showToastMessage(let image, let message):
            navigator.showToast(image, message)
        case .showErrorToast:
            navigator.showToast(DesignSystemAsset.warning.image, "에러가 발생했습니다")
        case .widgetAlert:
            navigator.showWidgetAlert()
        }
    }
}

extension MainViewReactor: BBAlertDelegate {
    func didTapAlertButton(_ alert: BBAlert?, index: Int?, button: BBButton) {
        if index == 0 {
            alert?.close()
            self.action.onNext(.pickConfirmButtonTapped)
        }
    }
}

extension MainViewReactor {
    private func updateMainData(_ state: State, _ data: MainViewEntity) -> State {
        var newState = state
        newState.familyname = data.familyName
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
        
        return newState
    }
    
    private func setCameraEnabled(_ state: State) -> State {
        var newState = state
        
        if currentState.pageIndex == 0 {
            newState.cameraEnabled = !currentState.isMeSurvivalUploadedToday
        } else {
            if (!currentState.isMeMissionUploadedToday) && currentState.isMissionUnlocked {
                newState.cameraEnabled = true
            } else {
                newState.cameraEnabled = false
            }
        }
        
        return newState
    }
    
    private func setBalloonText(_ state: State) -> State {
        var newState = state
        
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
        
        return newState
    }
    
    private func setDescriptionText(_ state: State) -> State {
        var newState = state
        
        guard let inTime = currentState.isInTime,
              inTime else {
            newState.description = .survivalNone
            return newState
        }
        
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
        
        return newState
    }
    
    private func calculateRemainingTime() -> (Bool, Int) {
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
        
        return (false, 1000)
    }
    
}
