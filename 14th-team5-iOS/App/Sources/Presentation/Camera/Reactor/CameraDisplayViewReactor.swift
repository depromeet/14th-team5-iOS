//
//  CameraDisplayViewReactor.swift
//  App
//
//  Created by Kim dohyun on 12/11/23.
//

import Foundation

import Data
import ReactorKit



public final class CameraDisplayViewReactor: Reactor {

    public var initialState: State
    private var cameraDisplayRepository: CameraDisplayImpl
    
    public enum Action {
        case viewDidLoad
        case didTapArchiveButton
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case setRenderImage(Data)
        case saveDeviceimage(Data)
    }
    
    public struct State {
        var isLoading: Bool
        @Pulse var displayData: Data
    }
    
    
    
    init(cameraDisplayRepository: CameraDisplayImpl, displayData: Data) {
        self.cameraDisplayRepository = cameraDisplayRepository
        self.initialState = State(isLoading: false, displayData: displayData)
        
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .concat(
                .just(.setLoading(true)),
                .just(.setRenderImage(self.currentState.displayData)),
                .just(.setLoading(false))
            )
        case .didTapArchiveButton:
            return .concat(
                .just(.setLoading(true)),
                .just(.saveDeviceimage(self.currentState.displayData)),
                .just(.setLoading(false))
            )
        }
    }
    
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        case let .setRenderImage(originalData):
            newState.displayData = originalData
        case let .saveDeviceimage(saveData):
            newState.displayData = saveData
            print("savedeviceImage: \(saveData)")
        }
        return newState
    }
    
    
}
