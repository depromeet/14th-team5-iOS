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
        // TODO: 임시 Action
        case didTapTakeButton(Void)
    }
    
    public enum Mutation {
        // TODO: 임시 Mutation
        case setTakeImage(Void)
    }
    
    public struct State {
        //TODO: 임시 State
        var isFlashMode: Bool
        var isSwitchPosition: Bool
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
        case .didTapTakeButton:
            return cameraRepository.fetchUploadImage().map { .setTakeImage($0) }
        }
        
    }
    
    public func reduce(state: State, mutation: Action) -> State {
        var newState = state
        switch mutation {
        case let .didTapTakeButton(isSelect):
            break
            
        }
        
        return newState
    }
    
    
    
    
    
}
