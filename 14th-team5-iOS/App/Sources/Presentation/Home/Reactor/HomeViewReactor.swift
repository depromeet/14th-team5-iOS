//
//  HomeViewReactor.swift
//  App
//
//  Created by 마경미 on 05.12.23.
//

import Foundation
import ReactorKit
import RxDataSources

final class HomeViewReactor: Reactor {
    enum Action {
//        case checkTime
        case setTimer
        case getFamilyInfo
    }
    
    enum Mutation {
//        case setTimerStatus
        case setRemainingTime(Int)
        case showInviteFamilyView
        case setFamilyCollectionView([SectionModel<String, ProfileData>])
    }
    
    struct State {
        var descriptionText: String = HomeStringLiterals.Description.standard
        var remainingTime: Int = 0
        var isShowingInviteFamilyView: Bool = false
        var familySections: [SectionModel<String, ProfileData>] = []
        var feedSections: [SectionModel<String, FeedData>] = SectionOfFeed.sections
    }
    
    let initialState: State = State()
}

extension HomeViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
//        case .checkTime:
//            return Observable.just(Mutation.setTimerStatus)
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
//        case .setTimerStatus:
//            newState.descriptionText = HomeStringLiterals.Description.standard
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

extension HomeViewReactor {
    private func calculateRemainingTime() -> Int {
        let calendar = Calendar.current
        let currentTime = Date()
        
        let isAfterNoon = calendar.component(.hour, from: currentTime) >= 12
        
        if isAfterNoon {
            if let nextMidnight = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: currentTime.addingTimeInterval(24 * 60 * 60)) {
                let timeDifference = calendar.dateComponents([.second], from: currentTime, to: nextMidnight)
                return max(0, timeDifference.second ?? 0)
            }
        }
        
        return 0
    }
}
