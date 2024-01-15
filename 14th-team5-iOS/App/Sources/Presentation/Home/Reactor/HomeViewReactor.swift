//
//  HomeViewReactor.swift
//  App
//
//  Created by 마경미 on 05.12.23.
//

import Foundation
import UIKit

import Core
import Domain

import ReactorKit
import RxDataSources

public final class HomeViewReactor: Reactor {
    public enum Action {
        case getTodayPostList
        case refreshCollectionview
        case startTimer
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case setDidPost
        case setDescriptionText(String)
        case showNoPostTodayView(Bool)
        case setPostCollectionView([SectionModel<String, PostListData>])
        case setRefreshing(Bool)
        case hideCamerButton(Bool)
        case setTimer(Int)
        case setTimerColor(UIColor)
    }
    
    public struct State {
        var isRefreshing: Bool = false
        var showLoading: Bool = true
        var didPost: Bool = false
        var isShowingNoPostTodayView: Bool = false
        
        @Pulse var timerLabelColor: UIColor = .white
        @Pulse var timer: String = ""
        @Pulse var isHideCameraButton: Bool = true
        @Pulse var descriptionText: String = HomeStrings.Description.standard
        @Pulse var feedSections: [SectionModel<String, PostListData>] = []
    }
    
    public let initialState: State = State()
    private let postRepository: PostListUseCaseProtocol
    
    init(postRepository: PostListUseCaseProtocol) {
        self.postRepository = postRepository
    }
}

extension HomeViewReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .getTodayPostList:
            let query: PostListQuery = PostListQuery(page: 1, size: 20, date: Date().toFormatString(with: "YYYY-MM-DD"), memberId: "", sort: .desc)
            return postRepository.excute(query: query)
                .asObservable()
                .flatMap { postList in
                    guard let postList,
                          !postList.postLists.isEmpty else {
                        return Observable.just(Mutation.showNoPostTodayView(true))
                    }
                    
                    var observables = [
                        Observable.just(Mutation.showNoPostTodayView(false)),
                        Observable.just(Mutation.setPostCollectionView([
                            SectionModel<String, PostListData>(model: "section1", items: postList.postLists)]))]
                    
                    if postList.selfUploaded {
                        observables.append(Observable.just(Mutation.setDidPost))
                    }
                    
                    if postList.allFamilyMembersUploaded {
                        observables.append(Observable.just(Mutation.setDescriptionText("우리 가족 모두가 사진을 올린 날🎉")))
                    }
                    
                    observables.append(Observable.just(Mutation.setRefreshing(false)))
                    return Observable.concat(observables)
                }
        case .refreshCollectionview:
            let getTodayPostListAction = Action.getTodayPostList
            return mutate(action: getTodayPostListAction)
        case .startTimer:
            return Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
                .startWith(0)
                .flatMap {_ in
                    let time = self.calculateRemainingTime()
                    
                    // 시간 이외
                    guard time > 0 else {
                        return Observable.concat([
                            Observable.just(Mutation.hideCamerButton(true)),
                            Observable.just(Mutation.setDescriptionText(HomeStrings.Timer.notTime)),
                            Observable.just(Mutation.setTimer(time))
                        ])
                    }
                    
                    // 1시간 전
                    if time <= 3600 && !self.currentState.didPost {
                        return Observable.concat([
                            Observable.just(Mutation.setTimer(time)),
                            Observable.just(Mutation.setTimerColor(.warningRed)),
                            Observable.just(Mutation.setDescriptionText("시간이 얼마 남지 않았어요!"))
                        ])
                    }
                            
                    return Observable.just(Mutation.setTimer(time))
                }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .showNoPostTodayView(isShow):
            newState.isShowingNoPostTodayView = isShow
        case let .setPostCollectionView(data):
            newState.feedSections = data
        case .setDidPost:
            newState.didPost = true
        case let .setDescriptionText(message):
            newState.descriptionText = message
        case .setLoading:
            newState.showLoading = false
        case let .setRefreshing(isRefreshing):
            newState.isRefreshing = isRefreshing
        case let .hideCamerButton(isHide):
            newState.isHideCameraButton = isHide
        case let .setTimer(time):
            newState.timer = time.setTimerFormat() ?? "00:00:00"
        case let .setTimerColor(color):
            newState.timerLabelColor = color
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
