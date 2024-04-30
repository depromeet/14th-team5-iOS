//
//  DescriptionReacto.swift
//  App
//
//  Created by 마경미 on 21.04.24.
//

import Foundation

import Core
import Domain

import ReactorKit

enum SurvivalDescription: String {
    case none = "매일 12-24시에 사진 한 장을 올려요"
    case full = "우리 가족 모두가 사진을 올린 날"
}

enum MissionDescription {
    case none(Int)
    case some(String)
    case full

    var description: String {
        switch self {
        case .none(let count):
            return "가족 중 \(count)명만 더 올리면 미션 열쇠를 받아요!"
        case .some(let string):
            return string
        case .full:
            return "우리 가족 모두가 미션을 성공한 날"
        }
    }
}

final class DescriptionReactor: Reactor {
    enum Action {
        case setPostType(PostType)
        case getMission
    }
    
    enum Mutation {
        case setDescriptionText(String)
        case setMission(String?)
        case setPostType(PostType)
    }
    
    struct State {
        var postType: PostType = .survival
        var description: String = "매일 12-24시에 사진 한 장을 올려요"
        var mission: String = "가족 중 2명만 더 올리면 미션 열쇠를 받아요!"
    }
    
    let initialState: State = State()
    let missionUseCase: GetTodayMissionUseCaseProtocol
    
    init(missionUseCase: GetTodayMissionUseCaseProtocol) {
        self.missionUseCase = missionUseCase
    }
}

extension DescriptionReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setPostType(let type):
            if type == .mission {
                return Observable.from([
                    Observable.just(Mutation.setPostType(type)),
                    self.mutate(action: .getMission)
                ]).flatMap { $0 }
            } else {
                return Observable.just(.setPostType(type))
            }
        case .getMission:
            return missionUseCase.execute()
                .asObservable()
                .flatMap {
                    return Observable.from([
                    .setDescriptionText($0?.content ?? "미션을 불러오는데 실패하였습니다."),
                    .setMission($0?.content)
                    ])
                }
            
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setPostType(let type):
            newState.postType = type
        case .setDescriptionText(let str):
            newState.description = str
        case .setMission(let mission):
            guard let mission else { return newState}
            newState.mission = mission
        }
        
        return newState
    }
}
