//
//  MainViewReactor.swift
//  App
//
//  Created by 마경미 on 05.12.23.
//

import Foundation
import ReactorKit
import RxDataSources

final class MainViewReactor: Reactor {
    enum Action {
        case checkTime
        case setTimer
        case getFamilyInfo
    }
    
    enum Mutation {
        case setTimerStatus
        case setRemainingTime(Int)
        case showInviteFamilyView
        case setFamilyCollectionView([SectionModel<String, ProfileData>])
    }
    
    struct State {
        var descriptionText: String = MainStringLiterals.Description.standard
        var remainingTime: Int = 0
        var isShowingInviteFamilyView: Bool = false
        var familySections: [SectionModel<String, ProfileData>] = []
        var feedSections: [SectionModel<String, FeedData>] = SectionOfFeed.sections
    }
    
    let initialState: State = State()
}

extension MainViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .checkTime:
            return Observable.just(Mutation.setTimerStatus)
        case .getFamilyInfo:
            //            if data.isEmpty
            return Observable.just(Mutation.showInviteFamilyView)
            //            else
            //            return Observable.just(Mutation.setFamilyCollectionView(data))
        case .setTimer:
            return Observable.interval(.seconds(1), scheduler: MainScheduler.instance)
                .map { (time: Int) in
                        .setRemainingTime(self.calculateRemainingTime())
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setTimerStatus:
            newState.descriptionText = MainStringLiterals.Description.standard
        case .showInviteFamilyView:
            newState.isShowingInviteFamilyView = true
        case let .setFamilyCollectionView(data):
            newState.familySections = data
        case let .setRemainingTime(time):
            newState.remainingTime = time
        }
        
        return newState
    }
}

extension MainViewReactor {
//    private func checkTime() -> TimerStatus {
//        return 
//    }
//    
    private func calculateRemainingTime() -> Int {
        let calendar = Calendar.current
        if let midnight = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date().addingTimeInterval(24 * 60 * 60)) {
            let timeDifference = calendar.dateComponents([.second], from: Date(), to: midnight)
            return max(0, timeDifference.second ?? 0)
        }
        return 0
    }
}
