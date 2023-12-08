//
//  CameraViewReactor.swift
//  App
//
//  Created by Kim dohyun on 12/6/23.
//

import Foundation

import Data
import ReactorKit


public final class CameraViewReactor: Reactor {
    
    public var initialState: State
    private var cameraRepository: CameraViewImpl
    
    public enum Action {
        case didTapFlashButton
        case didTapToggleButton
    }
    
    public enum Mutation {
        case setPosition(Bool)
        case setFlashMode
    }
    
    public struct State {
       @Pulse var isFlashMode: Bool
       @Pulse var isSwitchPosition: Bool
    }
    
    init(cameraRepository: CameraViewRepository) {
        self.cameraRepository = cameraRepository
        self.initialState = State(
            isFlashMode: false,
            isSwitchPosition: false
        )
    }
    
    
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapToggleButton:
            return cameraRepository.toggleCameraPosition(self.currentState.isSwitchPosition).map { .setPosition($0) }
        case .didTapFlashButton:
            return .empty()
        }
        
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setPosition(isPosition):
            newState.isSwitchPosition = isPosition
        case .setFlashMode: break
            
        }
        
        return newState
    }
    
    
    
    
    
}
