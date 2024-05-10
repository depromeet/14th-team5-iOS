//
//  MainCameraReactor.swift
//  App
//
//  Created by 마경미 on 30.04.24.
//

import UIKit

import Domain

import ReactorKit

enum BalloonText {
    case survivalStandard
    case cantMission
    case canMission
    case picker(Picker)
    case pickers([Picker])
    
    var message: String {
        switch self {
        case .survivalStandard:
            return "하루에 한번 사진을 올릴 수 있어요"
        case .cantMission:
            return "아직 미션 사진을 찍을 수 없어요"
        case .canMission:
            return "미션 사진을 찍으러 가볼까요?"
        case .picker(let picker):
            return "\(picker.displayName)님이 기다리고 있어요"
        case .pickers(let pickers):
            return "\(pickers.first?.displayName ?? "알 수 없음")님 외 \(pickers.count - 1)명이 기다리고 있어요"
        }
    }
}

final class MainCameraReactor: Reactor {
    enum Action {
        case setText(BalloonText)
    }
    
    enum Mutation {
        case updateText(BalloonText)
    }
    
    struct State {
        var balloonText: BalloonText = .survivalStandard
    }
    
    let initialState: State = State()
}

extension MainCameraReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setText(let text):
            return Observable.just(.updateText(text))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .updateText(let text):
            newState.balloonText = text
        }
        
        return newState
    }
}
