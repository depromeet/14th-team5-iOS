//
//  HomeViewReactor.swift
//  App
//
//  Created by 마경미 on 05.12.23.
//

import Foundation
import ReactorKit
import RxDataSources
import Core

final class HomeViewReactor: Reactor {
    enum Action {
//        case checkTime
        case tapInviteFamily
        case getFamilyInfo
        case getPostInfo
    }
    
    enum Mutation {
//        case setTimerStatus
        case showShareAcitivityView(URL?)
        case showInviteFamilyView
        case showNoPostTodayView
        case setFamilyCollectionView([SectionModel<String, ProfileData>])
        case setPostCollectionView([SectionModel<String, FeedData>])
    }
    
    struct State {
        var inviteLink: URL?
//        var isShowingShareAcitivityView: Bool = false
        var descriptionText: String = HomeStringLiterals.Description.standard
        var isShowingNoPostTodayView: Bool = false
        var isShowingInviteFamilyView: Bool = false
        var familySections: [SectionModel<String, ProfileData>] = []
        var feedSections: [SectionModel<String, FeedData>] = []
    }
    
    let initialState: State = State()
    public let provider: GlobalStateProviderType = GlobalStateProvider()
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
        case .getPostInfo:
//            if data.isEmpty
            return Observable.just(Mutation.showNoPostTodayView)
//            else
//            return Observable.just(Mutation.setPostCollectionView(data))
        case .tapInviteFamily:
            // 서버로부터 invitecode 받아오기
            return Observable.just(Mutation.showShareAcitivityView(URL(string: "https://github.com/depromeet/14th-team5-iOS")))
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
        case .showNoPostTodayView:
            newState.isShowingNoPostTodayView = true
        case let .setPostCollectionView(data):
            newState.feedSections = data
        case let .showShareAcitivityView(url):
            newState.inviteLink = url
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
