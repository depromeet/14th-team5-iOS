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
import Kingfisher

final class HomeViewReactor: Reactor {
    enum Action {
        case viewWillAppear
        case prefetchItems([PostSection.Item])
        case refreshCollectionview
        case startTimer
        case pagination(
            contentHeight: CGFloat,
            contentOffsetY: CGFloat,
            scrollViewHeight: CGFloat
        )
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case setDidPost
        case setDescriptionText(String)
        case showNoPostTodayView(Bool)
        case setRefreshing(Bool)
        case hideCamerButton(Bool)
        case setTimer(Int)
        case setTimerColor(UIColor)
        
        case initDataSource([PostSection.Item])
        case updateDataSource([PostSection.Item])
    }
    
    public struct State {
        var isRefreshing: Bool = false
        var showLoading: Bool = false
        var didPost: Bool = false
        var isShowingNoPostTodayView: Bool = false
        var isHideCameraButton: Bool = false
        var descriptionText: String = ""
        
        @Pulse var timerLabelColor: UIColor = .white
        @Pulse var timer: String = ""
        var postSections = PostSection.Model(
            model: 0, items: []
        )
    }
    
    public let initialState: State = State()
    private let postRepository: PostListUseCaseProtocol
    
    private var currentPage: Int = 0
    private var isLast: Bool = false
    
    init(postRepository: PostListUseCaseProtocol) {
        self.postRepository = postRepository
    }
}

extension HomeViewReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            currentPage = 1
            isLast = false
            
            let query = PostListQuery(page: currentPage, size: 10, date: Date().toFormatString(with: "YYYY-MM-DD"), memberId: "", sort: .desc)
//            let query = PostListQuery(page: currentPage, size: 10, date: "2024-01-28", memberId: "", sort: .desc)
            return postRepository.excute(query: query)
                .asObservable()
                .flatMap { postList in
                    guard let postList,
                          !postList.postLists.isEmpty else {
                        return Observable.concat(
                            .just(Mutation.setLoading(false)),
                            .just(Mutation.showNoPostTodayView(true)),
                            .just(Mutation.setLoading(true))
                        )
                    }
                    
                    let postSectionItem = postList.postLists.map(PostSection.Item.main)
                    var observables = [
                        Observable.just(Mutation.setLoading(false)),
                        Observable.just(Mutation.showNoPostTodayView(false)),
                        Observable.just(Mutation.initDataSource(postSectionItem))]
                    
                    if postList.selfUploaded {
                        observables.append(Observable.just(Mutation.hideCamerButton(true)))
                        observables.append(Observable.just(Mutation.setDidPost))
                    }
                    
                    if postList.allFamilyMembersUploaded {
                        observables.append(Observable.just(Mutation.setDescriptionText("우리 가족 모두가 사진을 올린 날🎉")))
                    }
                    
                    observables.append(Observable.just(Mutation.setRefreshing(false)))
                    observables.append(Observable.just(Mutation.setLoading(true)))
                    return Observable.concat(observables)
                }
        case let .prefetchItems(items):
            var urls = [URL]()
            items.forEach {
                if case let .main(posts) = $0,
                   let url = URL(string: posts.imageURL) {
                    urls.append(url)
                }
            }
            ImagePrefetcher(resources: urls).start()
            return .empty()
        case let .pagination(contentHeight, contentOffsetY, scrollViewHeight):
            let paddingSpace = contentHeight - contentOffsetY
            if paddingSpace < scrollViewHeight {
                return getPostLists()
            } else {
                return .empty()
            }
        case .refreshCollectionview:
            let getTodayPostListAction = Action.viewWillAppear
            return mutate(action: getTodayPostListAction)
        case .startTimer:
            return Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
                .startWith(0)
                .flatMap {_ in
                    let time = self.calculateRemainingTime()
                    
                    guard time > 0 else {
                        return Observable.concat([
                            Observable.just(Mutation.hideCamerButton(true)),
                            Observable.just(Mutation.setDescriptionText(HomeStrings.Description.standard)),
                            Observable.just(Mutation.setTimer(time))
                        ])
                    }
                    
                    var observables = [
                        Observable.just(Mutation.setTimer(time))
                    ]
                    
                    if time <= 3600 && !self.currentState.didPost {
                        observables.append(Observable.just(Mutation.hideCamerButton(false)))
                        observables.append(Observable.just(Mutation.setTimerColor(.warningRed)))
                        observables.append(Observable.just(Mutation.setDescriptionText("시간이 얼마 남지 않았어요!")))
                    } else {
                        observables.append(Observable.just(Mutation.setDescriptionText(HomeStrings.Description.standard)))
                    }
                    
                    return Observable.concat(observables)
                }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .showNoPostTodayView(isShow):
            newState.isShowingNoPostTodayView = isShow
        case .setDidPost:
            newState.didPost = true
        case let .setDescriptionText(message):
            newState.descriptionText = message
        case let .setLoading(showLoading):
            newState.showLoading = showLoading
        case let .setRefreshing(isRefreshing):
            newState.isRefreshing = isRefreshing
        case let .hideCamerButton(isHide):
            newState.isHideCameraButton = isHide
        case let .setTimer(time):
            newState.timer = time.setTimerFormat() ?? "00:00:00"
        case let .setTimerColor(color):
            newState.timerLabelColor = color
        case let .initDataSource(sectionItem):
            newState.postSections.items = sectionItem
        case let .updateDataSource(sectionItem):
            newState.postSections.items.append(contentsOf: sectionItem)
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
    
    private func getPostLists() -> Observable<Mutation> {
        self.currentPage += 1
        
        guard !isLast else {
            return Observable.empty()
        }
        
        let query = PostListQuery(page: currentPage, size: 10, date: Date().toFormatString(with: "YYYY-MM-DD"), memberId: "", sort: .desc)
        return postRepository.excute(query: query)
            .asObservable()
            .flatMap { postList -> Observable<Mutation> in
                guard let postList else {
                    return Observable.empty()
                }
                
                self.isLast = postList.isLast
                
                let postSectionItems = postList.postLists.map(PostSection.Item.main)
                return Observable.concat(
                    .just(Mutation.setLoading(false)),
                    .just(Mutation.updateDataSource(postSectionItems)),
                    .just(Mutation.setLoading(true))
                )
            }
    }
}
